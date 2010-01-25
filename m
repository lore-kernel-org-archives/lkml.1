Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314Ab0AYRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0AYRH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337Ab0AYRHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:07:23 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52634
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754317Ab0AYRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:07:18 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KWTBIT-02-8LS-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 18:06:47 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, andreas.herrmann3@amd.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable
 fixes
Message-ID: <20100125170647.GG14274@aftab>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
 <20100122174049.GC19425@aftab>
 <4B59E507.9060403@zytor.com>
 <20100123065953.GB15774@elte.hu>
 <20100123081132.GB7098@liondog.tnic>
 <20100123090135.GB20056@elte.hu>
 <20100123163223.GA30859@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100123163223.GA30859@liondog.tnic>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2010 17:06:30.0337 (UTC) FILETIME=[BD0B9B10:01CA9DE0]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, Jan 23, 2010 at 05:32:23PM +0100, Borislav Petkov wrote:
> > Well, if there's a crasher in there, then a minimal fix to address just that 
> > is preferred for .33 - and that can be tagged for -stable immediately.
> 
> As I said earlier, I don't believe we have machines in the wild to
> practically support the feature yet so we should be OK without a fix.
> Let me verify that next week and get back to you with a minimal fix in
> case we have any affected configurations.

I could verify that we don't need a minimal fix for .33 for the reason
above so the 5 fixes for .34 merge window should suffice completely.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

