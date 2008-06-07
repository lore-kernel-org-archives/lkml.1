Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbYFGPz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbYFGPz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYFGPzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:55:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:32208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYFGPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T/JUE2d2a8gB3E0xvuwIkAawzbQPfAo74YARERB+WPBYGyOncBTsF9cCgVK+WW36E/
         FcAUsAFDD3iVvix5NdSpLHuIfBXDS6KAuP+h/AyR4On5RumVB5w4oyT+HUU8Cn2Mlght
         LanMEu067t5TCwQfdC2sVlRZtjF3hh4MQa2P4=
Message-ID: <cd73a99e0806070855g5db5f0eel7667e1277f7ac586@mail.gmail.com>
Date: Sat, 7 Jun 2008 17:55:46 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/8] rename at91_nand -> atmel_nand: file names and Kconfig
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The AT91 NAND driver needs just a few tiny modifications to work on
> AVR32 as well. Rename it atmel_nand to reflect this.
>
> Also move the ECC register definitions into drivers/mtd/nand since they
> are only useful to the atmel_nand driver, and get rid of the useless
> filename at the top of each file.
>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
