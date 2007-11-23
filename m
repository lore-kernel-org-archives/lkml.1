Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXKWQbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXKWQbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 11:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXKWQbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 11:31:32 -0500
Received: from mail.atmel.fr ([81.80.104.162]:33849 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbXKWQbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:31:31 -0500
Message-ID: <4747006D.3080704@atmel.com>
Date: Fri, 23 Nov 2007 17:31:41 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Wifi chips on SDIO interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To follow up on a recent thread on the arm-linux mailing list, I would 
like to have your your feedback about SDIO wifi cards you are using with 
the brand new SDIO stack.

I look at the page on the MMC wiki :
http://mmc.drzeus.cx/wiki/SDIO
but cannot see a card using the Marvell 8xxx chipset : Can you give me
advice on which SDIO cards/module you are using.

Another point, do you know what the plans are for future SDIO wifi chips
support ?

The Marvell chip seems a bit particular as a wifi chip (802.11 stack
included in chip). Do you think that other chips are more or less
difficult to interface through SDIO ?

Is an Atheros-based card support planned ? (maybe more a madwifi people
question...)

Thanks for your help.
-- 
Nicolas Ferre
