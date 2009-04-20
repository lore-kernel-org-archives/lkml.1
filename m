Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZDTMwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZDTMwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZDTMw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:52:28 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:48016 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754818AbZDTMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:52:27 -0400
Date: Mon, 20 Apr 2009 14:26:12 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Antonio R. Costa" <costa.antonior@gmail.com>
Cc: linux@maxim.org.za, nicolas.ferre@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
Message-ID: <20090420122612.GB17483@game.jcrosoft.org>
References: <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 8072983807184382954
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:22 Tue 25 Nov     , Antonio R. Costa wrote:
> AT572D940HF (Diopsis) is an ARM926 + a 40-bits floating point DSP
> (mAgicV)
> 
> Reference for machine type:
> 1783    Atmel DIOPSIS AT572D940HF EK
> 
> This RFC patch starts from v2.6.26 because we needed to
> test it together with Xenomai 2.4.5.
> 
> This patch, if approved, will be rebased to the latest linux kernel.
> 
> New files in arch/arm/ directory:
> 
> 	arch/arm/configs/at572d940hfek_defconfig
> 
> 	arch/arm/mach-at91/at572d940hf.c
> 	arch/arm/mach-at91/at572d940hf_devices.c
> 	arch/arm/mach-at91/board-at572d940hf_ek.c
> 
Any news?

Best Regards,
J.
