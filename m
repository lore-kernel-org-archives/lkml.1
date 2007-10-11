Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbXJKLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbXJKLDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXJKLDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:03:08 -0400
Received: from pear.igowo.de ([81.95.0.210]:60242 "EHLO pear.igowo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXJKLDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:03:07 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: IDE DMA doesn't work with
	=?UTF-8?Q?pata=5Fvia=20and=20compact=20flas?= =?UTF-8?Q?h=20card?=
MIME-Version: 1.0
Date: Thu, 11 Oct 2007 13:03:05 +0200
From: <philipp@igowo.de>
In-Reply-To: <20071011111911.0d322827@the-village.bc.nu>
References: <20071011111911.0d322827@the-village.bc.nu>
Message-ID: <f3e1edf0cde8141d7145411c4ae3212d@localhost>
User-Agent: RoundCube Webmail/0.1-rc1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Oct 2007 11:19:11 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk>
wrote:
>> ones, when using DMA. Turning off DMA for the old IDE drivers or
>> patching ata_generic to handle my IDE controller and then deactivating
>> DMA in the BIOS works, but then disk I/O is unbelievable slow.. do you
>> have any idea how to fix it, so that DMA works?
>
> Does your CF/IDE adapter support DMA ?

Thank you for your answer :)

I thought CF/IDE adapters are mainly electrical adapters.. I've never seen
one which explicitly states the modes it supports. On the other hand it
says on the package: "Vista compatible" (whatever that means)

Is there some way I can figure it out? I'll have a deeper look on the
datasheet when I'm home again later, but I'm rather sure there wasn't
anything mentioning supporting data transfer modes..

Best regards,
Philipp

