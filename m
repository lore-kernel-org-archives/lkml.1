Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJRXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJRXSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 19:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYJRXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 19:18:32 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54673 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYJRXSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:31 -0400
Date: Sun, 19 Oct 2008 01:17:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Willy Tarreau <w@1wt.eu>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <20081018084504.GQ24654@1wt.eu>
Message-ID: <alpine.LRH.1.10.0810190114420.2000@twin.jikos.cz>
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com>
 <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Willy Tarreau wrote:

> confusion between 2.4.37 and 2.6.27. I have already tagged kernels with 
> wrong versions, having to fix by hand afterwards. It's really cumbersome 
> some times.

But this is only because you are maintaining a source code that is several 
years old, right? Would maintaining a series numbered 2002.x.y make your 
situation a lot better? Do you think you'd never make typo '2002 instead 
of 2006' any more?

Or how would you distingiush the kernel tree you are maintaing from the 
one Linus is maintaining?

-- 
Jiri Kosina
SUSE Labs

