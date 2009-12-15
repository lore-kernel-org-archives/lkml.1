Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbZLOWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbZLOWOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761352AbZLOWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:14:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53657 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761349AbZLOWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:13:59 -0500
Date: Tue, 15 Dec 2009 22:13:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
Message-ID: <20091215221357.GA26024@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:00:02PM +0100, Geert Uytterhoeven wrote:
> From e2def3261a58e9c0e56b710b2020858df010a2c1 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Tue, 15 Dec 2009 21:49:57 +0100
> Subject: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
> 
> commit 5fb4d38b19d95a5f980f0a10adba798f5b92128c ("mfd: Move WM831x to generic
> IRQ") didn't take into account that genirq support depends on GENERIC_HARDIRQS.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
