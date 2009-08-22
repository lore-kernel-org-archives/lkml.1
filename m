Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbZHVV4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbZHVV4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbZHVV4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:56:49 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53809 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188AbZHVV4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:56:48 -0400
Date: Sat, 22 Aug 2009 22:56:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
       mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org,
       manuel.lauss@gmail.com, ppisa@pikron.com, nico@cam.org,
       maen@marvell.com, s.hauer@pengutronix.de, tony@atomide.com,
       madhu.cr@ti.com, drzeus@drzeus.cx, ben-linux@fluff.org,
       avorontsov@ru.mvista.com, pierre@ossman.eu, sdhci-devel@lists.ossman.eu,
       saschasommer@freenet.de, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
Message-ID: <20090822215620.GA2367@trinity.fluff.org>
References: <200908220223.50588.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908220223.50588.marek.vasut@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, there is already quite a big series touching the s3cmci driver
in drivers/mmc/host/s3cmci.c which already have this conversion done.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

