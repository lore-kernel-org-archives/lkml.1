Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbZIBHbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbZIBHbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZIBHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:31:31 -0400
Received: from relay.atmel.no ([80.232.32.139]:62053 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbZIBHbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:31:31 -0400
Date: Wed, 2 Sep 2009 09:31:07 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: pierre@ossman.eu, avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, rob@emanuele.us,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH 1/2] atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)
Message-ID: <20090902093107.6a7cf93b@hskinnemoen-d830>
In-Reply-To: <1245778771-8158-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
	<1245778771-8158-1-git-send-email-nicolas.ferre@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> From: Rob Emanuele <rob@emanuele.us>
> 
> Unification of the atmel-mci driver to support the AT91 processors MCI
> interface.  The atmel-mci driver currently supports the AVR32 and this patch
> adds AT91 support.
> Add read/write proof selection switch dependent on chip availability of this
> feature.
> 
> To use this new driver on a at91 the platform driver for your board needs to
> updated.
> 
> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> [nicolas.ferre@atmel.com indent, Kconfig comment and one printk modification]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
