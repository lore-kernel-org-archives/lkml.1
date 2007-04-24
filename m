Return-Path: <linux-kernel-owner+w=401wt.eu-S1161482AbXDXOjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161482AbXDXOjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161488AbXDXOjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:39:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:63064 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161482AbXDXOjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mWf7rwopGGdk3lxszkupT1pdY1Fbegvywh8+ggrONaeI4WBByyhO5isLeakJNF9b67s/lUDWMy6bBljhqBUufMd+gttZalXr68j5jfGHjZ89pNjJDLXY+qLOimmSe/QmsRt/Coot6g6CtDu91m6Jyh9ydcMGXeMNj5bZhvbgeXo=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 10:39:43 -0400
User-Agent: KMail/1.9.6
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
References: <200704220959.34978.kernel@kolivas.org> <20070424070800.GA23463@elte.hu> <20070424072520.GA28387@elte.hu>
In-Reply-To: <20070424072520.GA28387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241039.44103.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Ingo Molnar wrote:
>* Ingo Molnar <mingo@elte.hu> wrote:
>> yeah, i guess this has little to do with X. I think in your scenario
>> it might have been smarter to either stop, or to renice the workloads
>> that took away CPU power from others to _positive_ nice levels.
>> Negative nice levels can indeed be dangerous.
>
>btw., was X itself at nice 0 or nice -10 when the lockup happened?
>
>	Ingo

Memory could be hazy Ingo, but I think X was at 0 when that occurred.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I use technology in order to hate it more properly.
		-- Nam June Paik
