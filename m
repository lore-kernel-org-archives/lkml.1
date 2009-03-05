Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZCEKY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZCEKY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZCEKYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:24:19 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41901 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751653AbZCEKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:24:18 -0500
Date: Thu, 5 Mar 2009 11:24:15 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Olaf Hering <olaf@aepfle.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-mtd@lists.infradead.org,
       Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing video
 RAM as block device
In-Reply-To: <alpine.LRH.2.00.0903050856490.26681@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0903051123240.2618@vixen.sonytel.be>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <AA44F8E7-5FBC-4378-A86D-C094ECABD625@aepfle.de> <alpine.LRH.2.00.0903050856490.26681@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Geert Uytterhoeven wrote:
> On Thu, 5 Mar 2009, Olaf Hering wrote:
> > I see our old mtddriver does not have modalias support for autoloading.
> 
> You forgot to backport commit 0a2d15b928e0b1673d4ed5f48d95af211b6fcc06
> ("mtd/ps3vram: Add modalias support to the ps3vram driver") to the openSuSE
> tree?

Or do you mean that udev doesn't load mtdblock automatically?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
