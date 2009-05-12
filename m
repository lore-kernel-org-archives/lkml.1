Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZELNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZELNk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZELNkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:40:17 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:5383 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751805AbZELNkQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:40:16 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fJzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJJ9YR-02-UVX-01
Date: Tue, 12 May 2009 15:39:50 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
	/proc/cpuinfo
Message-ID: <20090512133950.GA15474@aftab>
References: <1242112482.3283.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242112482.3283.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 May 2009 13:39:53.0281 (UTC) FILETIME=[213F7B10:01C9D307]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 12:44:42PM +0530, Jaswinder Singh Rajput wrote:
> 
> Here are 2 patches for adding new field extended_cpuid_level, please
> choose PATCH whichever is more appropriate:
> 
> PATCH 1:
> Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo
> 
> extended_cpuid_level also gives useful information like cpuid_level
> and very useful for AMD processors.
> 
> Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.

and this is needed because... ?!

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

