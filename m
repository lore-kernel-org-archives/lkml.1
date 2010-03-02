Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0CBPiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:38:25 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:31712
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751495Ab0CBPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:38:23 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYNVFJ-02-4ES-02
X-M-MSG: 
Date: Tue, 2 Mar 2010 16:38:07 +0100
From: Robert Richter <robert.richter@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20100302153807.GI13205@erda.amd.com>
References: <20090622165936.0bb776e1@skybase>
 <20090622150553.GA14363@elte.hu>
 <20090622171834.0df64aea@skybase>
 <20090622152937.GA17512@elte.hu>
 <20090622173611.3b583c95@skybase>
 <20090622154030.GA19076@elte.hu>
 <20090624185100.6ca7e82a@skybase>
 <4B8D1942.8060405@nokia.com>
 <20100302160110.5fd14f5f@mschwide.boeblingen.de.ibm.com>
 <alpine.LFD.2.00.1003021605570.4245@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003021605570.4245@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Mar 2010 15:38:08.0316 (UTC) FILETIME=[5BAA67C0:01CABA1E]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.03.10 16:08:09, Thomas Gleixner wrote:
> > Patch against current git. Ingo, Thomas: one for the timer tree I guess.
> 
> No objections from my side, but shouldn't that go via Robert ?

I will send the patch upstream.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

