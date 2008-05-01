Return-Path: <linux-kernel-owner+w=401wt.eu-S1762933AbYEARJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762933AbYEARJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbYEARJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:09:07 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:33899 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYEARJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:09:06 -0400
Date: Thu, 01 May 2008 19:09:03 +0200
Message-Id: <261708587@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: Re: RFC: starting a kernel-testers group for newbies
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1973dFkF4Bdz79QNURWUfVDd3pkKGkDSKU5298hZF3Dgwmcq
 jTwy1Mm70jNGKl/0J2U0pb4i1uMkbYHBFnr9ntXJdb2BWdw+e0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>We need to send them to a URL that lists all the known bugs and have them pick one,
>any one, and have them solve it. This would be the best way to learn part of the kernel.

what about adding some link to 

"http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=VERIFIED&bug_status=DEFERRED&bug_status=NEEDINFO&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Bug+Number&field0-0-0=noop&type0-0-0=noop&value0-0-0="

on www.kernel.org or doing that via redirect from "http://bugs.kernel.org" ?

sorting results of bugzilla search could need some enhancement, btw. 
for example, it seems i cannot sort by ID top/down or sorting by date.....

it`s not obvious enough, what bugs exist - it`s all hidden in bugzilla and in lkml (and tons of other bugtrackers, forums, mailinglists....).
furthermore, it`s also not obvious, that everyone is invited to work together with the kernel devs to solve the bugs.





List:       linux-kernel
Subject:    Re: RFC: starting a kernel-testers group for newbies
From:       Steven Rostedt <rostedt () goodmis ! org>
Date:       2008-05-01 16:38:23
Message-ID: Pine.LNX.4.58.0805011217200.11101 () gandalf ! stny ! rr ! com
[Download message RAW]


On Thu, 1 May 2008, Andrew Morton wrote:
>
> Arjan's fourth fallacy: "We don't make (effective) prioritization
> decisions." lol.  This implies that someone somewhere once sat down and
> wondered which bug he should most effectively work on.  Well, we don't do
> that.  We ignore _all_ the bugs in favour of busily writing new ones.

And actually, core kernel developers are best for writing new bugs.

Really, the way I started out learning how the kernel ticks was to go and
try to solve some bugs that I was seeing (this was years ago). I get
people asking that they want to learn to be a kernel developer and they
ask what new feature should they work on? Well, honestly, the last thing
a newbie kernel developer should be doing is writing new bugs. We need to
send them to a URL that lists all the known bugs and have them pick one,
any one, and have them solve it. This would be the best way to learn part
of the kernel.

I even find that I understand my own code better when I'm in the debugging
phase.

People here mention differnt places to look at code, and besides the
kerneloops.org I really don't even know where to look for bugs, because I
haven't seen a URL to point me to.

The next time someone asks me how to get started in kernel programming, I
would love to tell them to go and look here, and solve the bugs. I'm
guessing that I should just point them to:

  http://janitor.kernelnewbies.org/

and tell them to focus on real bugs (not just comments and such) to get
fixed if they really want to learn the kernel.

-- Steve




_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

