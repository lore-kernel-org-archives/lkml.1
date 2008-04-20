Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYDTXBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYDTXBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYDTXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:01:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59595 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbYDTXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:01:29 -0400
Date: Mon, 21 Apr 2008 00:01:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Conke Hu <conke.hu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com
Subject: Re: [PATCH] add AT73C213 DAC support for AT91SAM9261
Message-ID: <20080420230104.GA19490@flint.arm.linux.org.uk>
References: <5767b9100804041503o7395ff34nd13002c111e11c8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5767b9100804041503o7395ff34nd13002c111e11c8a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2008 at 06:03:32AM +0800, Conke Hu wrote:
> Many AT91SAM9261-based boards use AT73C213 as external audio DAC, this
> patch makes it work.

Please send AT91 patches to Andrew Victor.

> Signed-off-by: Conke Hu <conke.hu@gmail.com>
> ---------------------------------------
> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c
> b/arch/arm/mach-at91/at91sam9261_devices.c
> old mode 100644
> new mode 100755

This isn't an executable.

> diff --git a/arch/arm/mach-at91/board-sam9261ek.c
> b/arch/arm/mach-at91/board-sam9261ek.c
> old mode 100644
> new mode 100755

Neither is this.  Please don't change their modes.  The same goes
for the other two files that show up as this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
