Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYGXRxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYGXRxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGXRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:53:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:34207 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYGXRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:53:03 -0400
Date: Thu, 24 Jul 2008 21:50:32 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: wim@iguana.be, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: delete unused driver mpc8xx_wdt.c
Message-ID: <20080724215032.0d940f0f@vitb-lp.dev.rtsoft.ru>
In-Reply-To: <488857CD.6080007@scram.de>
References: <488857CD.6080007@scram.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Thu, 24 Jul 2008 12:22:05 +0200
Jochen Friedrich <jochen@scram.de> пишет:

> The watchdog driver mpc8xx_wdt.c was a device interface to
> arch/ppc/syslib/m8xx_wdt.c for MPC8xx hardware. Now that ARCH=ppc is
> gone, this driver is of no more use. For ARCH=powerpc, MPC8xx hardware
> is supported by mpc8xxx_wdt.c.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>

Acked-by: Vitaly Bordug <vitb@kernel.crashing.org>

-Vitaly
