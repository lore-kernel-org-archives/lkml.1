Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXLSJyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXLSJyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXLSJyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:54:31 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63082 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbXLSJya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:54:30 -0500
Date: Wed, 19 Dec 2007 10:54:00 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Vadim Yatsenko" <vadim.yatsenko@malva.ua>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       <kernel@avr32linux.org>, <linux-kernel@vger.kernel.org>,
       "Remy Bohmer" <linux@bohmer.net>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 0/5] atmel_serial: Cleanups, irq handler splitup & DMA
Message-ID: <20071219105400.163da8fb@dhcp-252-066.norway.atmel.com>
In-Reply-To: <00fc01c84210$f20dcdc0$3304200a@vadimtmp>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
	<00fc01c84210$f20dcdc0$3304200a@vadimtmp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 09:29:52 +0200
"Vadim Yatsenko" <vadim.yatsenko@malva.ua> wrote:

> What prepatches one need to aply to what kernel version (vanila, git, ...) 
> before these?

They should apply to a fresh checkout of Linus' git tree.

If you want to use 2.6.23, you need to apply this patch first:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=19cd7537bdae6685c31677a01e08850612ba87f6

Haavard
