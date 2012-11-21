ometa MAliceSemantics
  Program :at createScope:scope
          trans*:declarations                       ->
  Function :at :name :returnType :args :body        ->
  Block :at createScope:scope trans* exitScope      ->
  Variable :at :name :type :value                   ->
  Array :at :name :size :elementType                ->
  Skip :at                                          ->
  Assignment :at :name :value                       ->
  Decrement :at :name                               ->
  Increment :at :name                               ->
  Output :at :value                                 ->
  Call :at :name :args                              ->
  Return :at :value                                 ->
  Input :at :name                                   ->
  If :at :cond [trans*] [trans*]                    ->
  Until :at :cond [trans*]                          ->
  Logic :at :op :b1 :b2                             ->
  Compare :at :op :e1 :e2                           ->
  Arithmetic :at :op :e1 :e2                        ->
  Element :at :array :at                            ->
  createScope     -> outerScope = @currentScope
                     @currentScope = new Scope outerScope, {}
  exitScope       -> @currentScope = @currentScope.outer