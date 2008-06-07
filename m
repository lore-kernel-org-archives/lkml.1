Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbYFGQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbYFGQJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760167AbYFGQI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:08:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:40495 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbYFGQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vvdGQsiHTHsuImcxU9dogwEDYbEvdUEyz9OjOJkYizbeaHWTxi+0VnuyznIdHwwkqr
         2SqyhhP+gwmDn4sxZOsZcse+Vecpyw0h+uv2eBxSM904zMAHcWRFANBi6AndSaEwikGs
         PiW/DFLUDNl1bvWEW/gtRpA6wQ+/+uw8Y8+No=
Message-ID: <cd73a99e0806070908mbc1f33cg37cc23a426ffca24@mail.gmail.com>
Date: Sat, 7 Jun 2008 18:08:55 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 7/8] atmel_nand: make available on AVR32
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212768298-13614-8-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-7-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-8-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make the atmel_nand driver selectable on AVR32, and update the Kconfig
> help text to reflect this.
>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
