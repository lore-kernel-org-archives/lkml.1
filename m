Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXICKOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXICKOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbXICKOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:14:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:49644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXICKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:14:04 -0400
Message-ID: <46DBDE75.90203@anagramm.de>
Date: Mon, 03 Sep 2007 12:14:13 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
References: <1188804323.29566.6.camel@roc-laptop>
In-Reply-To: <1188804323.29566.6.camel@roc-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/SrXRHECjWAqojUKchZQbMKHMHG6yCJrJmcn0
 TZkl+obNsA7u4+6BOVfaLyqG0Ftez1Sx+4y9mKXuBX9ZHARmqy
 L3QavCoKqcvwj48ggx+NA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bryan!

Bryan Wu schrieb:
> This is the driver for latest Blackfin BF54x nand flash controller
> 
>  - use nand_chip and mtd_info common nand driver interface
>  - provide both PIO and dma operation
>  - compiled with ezkit bf548 configuration
>  - use hardware 1-bit ECC
>  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs

Looks great!

Will this driver also work for the new BF52x series of the Blackfin Series?
(Or is it planned to make it work for... anytime soon.)

Thank you!
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
