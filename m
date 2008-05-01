Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbYEAR1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbYEAR1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYEAR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:27:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139AbYEAR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:27:46 -0400
Date: Thu, 1 May 2008 13:27:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: devzero@web.de
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       jirislaby@gmail.com
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <261708587@web.de>
Message-ID: <Pine.LNX.4.58.0805011325470.11101@gandalf.stny.rr.com>
References: <261708587@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Please don't strip the CC list. It may be a month before those on the CC
  actually read your email ]

Just replying with the missing CC.

-- Steve


On Thu, 1 May 2008 devzero@web.de wrote:

> >We need to send them to a URL that lists all the known bugs and have them pick one,
> >any one, and have them solve it. This would be the best way to learn part of the kernel.
>
> what about adding some link to
>
> "http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=VERIFIED&bug_status=DEFERRED&bug_status=NEEDINFO&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Bug+Number&field0-0-0=noop&type0-0-0=noop&value0-0-0="
>
> on www.kernel.org or doing that via redirect from "http://bugs.kernel.org" ?
>
> sorting results of bugzilla search could need some enhancement, btw.
> for example, it seems i cannot sort by ID top/down or sorting by date.....
>
> it`s not obvious enough, what bugs exist - it`s all hidden in bugzilla and in lkml (and tons of other bugtrackers, forums, mailinglists....).
> furthermore, it`s also not obvious, that everyone is invited to work together with the kernel devs to solve the bugs.
>
