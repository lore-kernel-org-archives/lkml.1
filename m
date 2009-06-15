Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbZFOQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbZFOQU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFOQUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:20:18 -0400
Received: from mail.atmel.fr ([81.80.104.162]:50378 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZFOQUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:20:17 -0400
Message-ID: <4A3674B0.8050004@atmel.com>
Date: Mon, 15 Jun 2009 18:20:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH 5/6] Unified AVR32/AT91 MCI Driver Support for a VCC Pin
References: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
In-Reply-To: <c8284b5b0906121802h3545fbfflf498fbba30fe42be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
> Add support to the atmel-mci driver for a VCC pin in order to conserve
> power if the MMC interface is powered down.

Can you elaborate a bit more. In particular, I do not understand the
concept of "vcc_pin_act_low".

[..]

Thanks. Bye,
-- 
Nicolas Ferre

