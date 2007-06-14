Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXFNWdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXFNWdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXFNWda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:33:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXFNWd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:33:29 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132140.13490.dhazelton@enter.net>
	<20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net>
	<20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org>
	<ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org>
	<orvedq9s0d.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141402400.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 19:31:52 -0300
In-Reply-To: <alpine.LFD.0.98.0706141402400.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 14\:23\:38 -0700 \(PDT\)")
Message-ID: <ortzta88x3.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> From the very beginning of Linux, even before I chose the GPLv2 as the 
> license, the thing I cared about was that source code be freely available. 

Ok, the MIT license could get you that.  Even public domain could.

> I didn't want money, I didn't want hardware, I just wanted the
> improvements back.

GPL won't get you that.  You want a non-Free Software license.

It will only as long as people play along nicely and perceive the
benefits of cooperation.  But some players don't.

> So given that background, which license do you _think_ I should have 
> chosen?

I can't morally recommend a non-Free Software license.

> And given that background, do you see why the GPLv2 is _still_ better than 
> the GPLv3?

No.  Honestly, I really don't.  Even when I try and look at it from
your perspective, that you described very beautifully in the rest of
the message that I snipped, it's still a mistery to me why you think
permitting Tivoization could possibly be advantageous to your project.

What is it in the anti-Tivoization provision that gets you any less
improvements back?

If anything, I'd think that, by not permitting TiVO to prohibit users
from running modified versions of your code that they don't authorize
themselves, these users would do *more* than TiVO alone ever could,
and if a fraction of them contributes something back, you're way
better off.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
