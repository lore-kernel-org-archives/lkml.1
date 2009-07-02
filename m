Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZGBQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZGBQIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZGBQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:08:26 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3449 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGBQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:08:26 -0400
Subject: Re: [PATCH] MAINTAINERS: Add entry for Wolfson PMIC drivers
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 09:08:23 -0700
Message-Id: <1246550903.28915.87.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 16:43 +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi Mark.

> diff --git a/MAINTAINERS b/MAINTAINERS

[]

> +F:	drivers/leds/leds-wm83*.c
> +F:	drivers/mfd/wm8*.c
> +F:	drivers/power/wm83*.c
> +F:	drivers/rtc/rtc-wm83*.c
> +F:	drivers/regulator/wm8*.c
> +F:	drivers/watchdog/wm83*_wdt.c

Maybe this pattern is complete enough?

F:	drivers/*/*wm8*.c

> +F:	sound/soc/codecs/wm8350.c
> +F:	sound/soc/codecs/wm8400.c

What about the other wm8 codecs?  Maybe:

F:	sound/soc/codecs/wm8* ?


