Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZB1JqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZB1JqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZB1JqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:46:10 -0500
Received: from gw.goop.org ([64.81.55.164]:33500 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZB1JqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:46:08 -0500
Message-ID: <49A907DD.6010408@goop.org>
Date: Sat, 28 Feb 2009 01:46:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu>
In-Reply-To: <20090228084254.GA29342@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Personally i'd like to see a sufficient reply to the mmap-perf 
> paravirt regressions pointed out by Nick and reproduced by 
> myself as well. (They were in the 4-5% macro-performance range 
> iirc, which is huge.)
>
> So i havent seen any real progress on reducing native kernel 
> overhead with paravirt. Patches were sent but no measurements 
> were done and it seemed to have all fizzled out while the dom0 
> patches are being pursued.
>   

Hm, I'm not sure what you want me to do here.  I sent out patches, they 
got merged, I posted the results of my measurements showing that the 
patches made a substantial improvement.  I'd love to see confirmation 
from others that the patches help them, but I don't think you can say 
I've been unresponsive about this.

    J
