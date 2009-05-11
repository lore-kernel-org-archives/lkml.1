Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZEKQaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZEKQaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZEKQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:30:26 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50157 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZEKQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:30:25 -0400
X-BigFish: VPS-37(z34a4jz1432R62a3L98dR936eQ4015L1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJHN5U-03-HK2-01
Date: Mon, 11 May 2009 18:29:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly
	access miscellaneous MSRs
Message-ID: <20090511162955.GE10722@erda.amd.com>
References: <1242058494.5139.7.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1242058494.5139.7.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 May 2009 16:29:57.0462 (UTC) FILETIME=[B9002F60:01C9D255]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.09 21:44:54, Jaswinder Singh Rajput wrote:
> Complete log is available at:
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=shortlog;h=x86/cpufeature
> 
> The following changes since commit 3e0c373749d7eb5b354ac0b043f2b2cdf84eefef:
>   Yinghai Lu (1):
>         x86: clean up and fix setup_clear/force_cpu_cap handling
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git x86/cpufeature
> 
> Jaswinder Singh Rajput (15):
>       x86: Add cpufeature for Processor Name
>       x86: Add cpufeatures for Advanced Power Management
>       x86: Add cpufeature for Microcode update
>       x86: Add cpufeature for Cache MSRs
>       x86: Add cpufeature for Hard and Soft Poweron configuration
>       x86: Add cpufeature for Scaleable bus speed
>       x86: Add cpufeature for Miscellaneous Features
>       x86: Add cpufeature for Platform feature
>       x86: Add cpufeature for Hardware configuration
>       x86: Add cpufeature for System configuration
>       x86: Add cpufeature for System management mode (SMM)
>       x86: Add cpufeature for MM configuration
>       x86: Add cpufeature for Bus configuration
>       x86: Add cpufeature for performance frequency APERF/MPERF
>       x86: Add cpufeature for ancient performance monitoring

Jaswinder,

this is the last time I will mention this.

Please send a patch set with numbered patches. Your pull requests are
hard to review. Even maintainers send their patches this way for
review though the patches are available also in some git
repositories. Make these patches relative to a common tree (linux-2.6
or tip) or the maintainers tree (in this case also tip). Doing so,
others can apply the patches easily in a local repository. This will
reduce the efforts to review and test your patches and you will
probably get more feedback.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

