Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZGFJUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZGFJUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZGFJUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:20:03 -0400
Received: from relay.atmel.no ([80.232.32.139]:58395 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZGFJUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:20:02 -0400
Date: Mon, 6 Jul 2009 11:19:54 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, kernel@avr32linux.org,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH] avr32: add two new at91 to cpu.h definition
Message-ID: <20090706111954.723badb9@hskinnemoen-d830>
In-Reply-To: <1246875312-6824-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246875312-6824-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> Somme common drivers will need those at91 cpu_is_xxx() definitions. As
> at91sam9g10 and at91sam9g45 are on the way to linus' tree, here is the patch
> that adds those chips to cpu.h in AVR32 architecture.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

> ---
> Inclusion in linux-2.6-arm.git/devel:
> 
> at91sam9g10: b784b7c03723891876c9053c589150a4062f9455
> at91sam9g45: fddcc0ae58edefeb7ac1e460411d7dfbe8ebdacc

Do you want me to take this patch, or is it better if it goes in along
the rest through the ARM tree?

Haavard
