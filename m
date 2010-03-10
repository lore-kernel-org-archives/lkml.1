Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0CJCxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:53:53 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43435 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0CJCxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:53:50 -0500
Date: Wed, 10 Mar 2010 11:53:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: Magnus Damm <damm@igel.co.jp>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] serial/sh_sci: Fix build failure for non-sh architectures
Message-ID: <20100310025301.GA17693@linux-sh.org>
References: <201003092118.26274.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003092118.26274.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 09:18:25PM +0100, Peter H?we wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a build failure for various arm based defconfigs
> [1][2][3] and maybe other architectures/configs.
> 
> The build failure was introduced by the sh specific patch [4]
> "serial: sh-sci: Add DMA support"
> by Guennadi Liakhovetski
> 
> Patch against linux-next of 20100309

Please Cc linux-sh@vger.kernel.org so these things make it in to
patchwork in the future.

> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2248992/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/2248996/
> [3] http://kisskb.ellerman.id.au/kisskb/buildresult/2248998/
> [4] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=73a19e4c0301908ce6346715fd08a74308451f5a
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied, thanks.
