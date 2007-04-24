Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXDXOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXDXOmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXDXOmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:42:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:64529 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXDXOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GrNucBMy5mnIDkPhHzolo5hW7kfNIYIHYVBLrXDdktgkmrz09iBOIrE4MFMPIKfeb82+BZpWTxsiSV2aOlR1yAs79pj33odTa14the+/V7rGdPC5kjiOJw4WcIx2DpnRDUR1NEpK7HBdEIStfGnFIvO35kVrc2dfk8xiBXcNMlM=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 10:42:11 -0400
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
Message-Id: <200704241042.11743.gene.heskett@gmail.com>
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

Memory could be fuzzy Ingo, but I think it was at 0 at the time.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I know it all.  I just can't remember it all at once.
