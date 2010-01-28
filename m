Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456Ab0A1WT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0A1WT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353Ab0A1WTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:19:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0A1WTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:19:24 -0500
Date: Thu, 28 Jan 2010 22:19:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/06] ARM: Add sh7372 and AP4EVB support
Message-ID: <20100128221909.GB23471@n2100.arm.linux.org.uk>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124101.8982.71955.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128124101.8982.71955.sendpatchset@rxone.opensource.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:41:01PM +0900, Magnus Damm wrote:
> --- 0001/arch/arm/tools/mach-types
> +++ work/arch/arm/tools/mach-types	2010-01-21 19:51:03.000000000 +0900
> @@ -2578,3 +2578,4 @@ glacier			MACH_GLACIER		GLACIER			2592
>  phrazer_bulldog		MACH_PHRAZER_BULLDOG	PHRAZER_BULLDOG		2593
>  omap3_bulldog		MACH_OMAP3_BULLDOG	OMAP3_BULLDOG		2594
>  pca101			MACH_PCA101		PCA101			2595
> +ap4evb			MACH_AP4EVB		AP4EVB			2630

Note that this'll be included in the mach-types update which'll
probably be pushed to Linus probably tonight.
