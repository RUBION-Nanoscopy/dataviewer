classdef DBInitializingSteps < handle
% DBINITIALIZINGSTEP  Class simplifying the start process notifications    

    properties (Access = protected)
        Steps = {}
        StepsMap = struct();
        CalledSteps = {};
        
        MsgCb;
        ProgressCb;
        SubprogressCb;
    end
    
    properties (Constant)
        CALLBACKSTEP = 0
        LOOPSTEP = 1
        CELLFUNSTEP = 2
    end
    
    methods 
        function self = DBInitializingSteps (msgCb, progressCb, subprogressCb)
            self.MsgCb = msgCb;
            self.ProgressCb = progressCb;
            self.SubprogressCb = subprogressCb;
        end
        
        
    end
    
    methods 
        function addStep( self, id, msg, varargin )
            n = self.i_addStep(id, msg, self.CALLBACKSTEP);
            self.Steps{n} = phutils.structset(...
                self.Steps{n}, varargin{:} ...
            );
        end % addStep
        
        function addLoopStep( self, id, msg, loopobj, loopcallback, varargin)
            n = self.i_addStep(id, msg, self.LOOPSTEP);
            self.Steps{n}.( 'loopobj' ) = loopobj;
            self.Steps{n}.( 'loopcallback' ) = loopcallback;
            self.Steps{n}.( 'loopcallbackargs' ) = varargin;
        end % addLoopStep
        
        function callStepById(self, id)
            i = cellfun(@(x)(strcmp(x.id,id)),self.Steps)==1;
            self.performStep(i);
            
        end
        function callAllSteps(self)
            for cnt = 1:numel(self.Steps)
                self.performStep(cnt);
            end
        end
        
    end % public methods
    methods (Access = protected)
        
        function n = i_addStep(self, id, msg, type )
            self.Steps{end + 1} = struct(...
                'id', id, ...
                'msg', msg, ...
                'type', type ...
            );
            n = numel(self.Steps);
            self.StepsMap.(id)=n;
        end % i_addStep
        
        function performStep(self, i)
            self.MsgCb(self.Steps{i}.msg);
            self.SubprogressCb(numel(self.CalledSteps)/numel(self.Steps));
            step = self.Steps{i};
            % fprintf('Performing step %s\n', step.id);
            switch step.type
                case self.CALLBACKSTEP
                    l = numel(step.Callbacks);
                    self.SubprogressCb(0);
                    for cnt = 1:l
                        step.Callbacks{cnt}();
                        self.SubprogressCb((cnt)/l);
                    end
                    self.SubprogressCb(1);
                case self.LOOPSTEP
                    self.SubprogressCb(0);
                    if isa (step.loopobj, 'function_handle')
                        lo = step.loopobj();
                    else
                        lo = step.loopobj;
                    end
                    l = numel(lo);
                    for cnt = 1:l
                        step.loopcallback(cnt, step.loopobj, step.loopcallbackargs{:}); 
                        self.SubprogressCb(cnt/l);
                    end
                    self.SubprogressCb(1);  
            end
            self.CalledSteps{end+1}=step.id;
            self.ProgressCb((numel(self.CalledSteps))/numel(self.Steps));
        end
        
    end % protected methods    
end