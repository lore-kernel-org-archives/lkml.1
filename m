Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZLOK60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZLOK60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbZLOK6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:58:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59331 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757127AbZLOK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:58:22 -0500
Date: Tue, 15 Dec 2009 10:58:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v2] leds: Add LED class driver for regulator driven
	LEDs.
Message-ID: <20091215105820.GA14026@opensource.wolfsonmicro.com>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it> <1260194893-30149-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260194893-30149-1-git-send-email-ospite@studenti.unina.it>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:08:13PM +0100, Antonio Ospite wrote:
> This driver provides an interface for controlling LEDs (or vibrators)
> connected to PMICs for which there is a regulator framework driver.
> 
> This driver can be used, for instance, to control vibrator on all Motorola EZX
> phones using the pcap-regulator driver services.
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Looks OK to me.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
