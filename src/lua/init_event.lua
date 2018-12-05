local e={}
function e:new(o)
 o=o or{}
 o._on={}
 function o:on(e,l)self._on[e]=self._on[e]or{}table.insert(self._on[e],l)end
 function o:l(e)return self._on[e]or{}end
 function o:emit(e,...)for _,l in ipairs(self:l(e))do if"function"==type(l)then l(...)end end
end
return o
end
return function (t)return e end
