Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXHJVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXHJVPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXHJVPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:15:36 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1076 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbXHJVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:15:35 -0400
Date: Fri, 10 Aug 2007 23:15:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Willy Tarreau <w@1wt.eu>
cc: Michael Chang <thenewme91@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070810194705.GH6002@1wt.eu>
Message-ID: <Pine.LNX.4.64.0708102235320.1817@scrub.home>
References: <p73ps27npu0.fsf@bingen.suse.de>
 <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
 <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home>
 <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home>
 <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home>
 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
 <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 10 Aug 2007, Willy Tarreau wrote:

> fortunately all bug reporters are not like you. It's amazing how long
> you can resist sending a simple bug report to a developer!

I'm more amazed how long Ingo can resist providing some explanations (not 
just about this problem).
It's not like I haven't given him anything, he already has the test 
programs, he already knows the system configuration.
Well, I've sent him the stuff now...

> Maybe you
> consider that you need to fix the bug by yourself after you understand
> the code,

Fixing the bug requires some knowledge what the code is intended to do.

> Please try to be a little bit more transparent if you really want the
> bugs fixed, and don't behave as if you wanted this bug to survive
> till -final.

Could you please ask Ingo the same? I'm simply trying to get some 
transparancy into the CFS design. Without further information it's 
difficult to tell, whether something is supposed to work this way or it's 
a bug.

In this case it's quite possible that due to a recent change my testcase 
doesn't work anymore. Should I consider the problem fixed or did it just 
go into hiding? Without more information it's difficult to verify this 
independently.

bye, Roman
