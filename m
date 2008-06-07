Return-Path: <linux-kernel-owner+w=401wt.eu-S1763216AbYFGP7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216AbYFGP7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYFGP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:59:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:34788 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYFGP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UHB1xBjvQw3M1+ZaO7dL8E/ViQAb1cp7FFIA/y3dwVcGBAvI4sTUk9MMyAyYzKsIoE
         zDHsekjduinbAT1J1OTpav7N4zht9ZOXNO1RsrviTrcEsWEhRhmbHJ+Wq3RtLF5sbhre
         WWpMyFPcVkqVf0YcmQCYeeKLn5ABLW14V5i7w=
Message-ID: <cd73a99e0806070859v20062abw6b16d1c9a99f5923@mail.gmail.com>
Date: Sat, 7 Jun 2008 17:59:41 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 3/8] rename at91_nand -> atmel_nand: internal symbols
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is basically s/at91_nand/atmel_nand/g with some manual inspection.

Looks fine.

> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
