Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXJKLkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXJKLkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbXJKLjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:39:54 -0400
Received: from pear.igowo.de ([81.95.0.210]:51872 "EHLO pear.igowo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbXJKLjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:39:53 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: IDE DMA doesn't work with
	=?UTF-8?Q?pata=5Fvia=20and=20compact=20flas?= =?UTF-8?Q?h=20card?=
MIME-Version: 1.0
Date: Thu, 11 Oct 2007 13:39:52 +0200
From: <philipp@igowo.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071011111911.0d322827@the-village.bc.nu>
References: <20071011111911.0d322827@the-village.bc.nu>
Message-ID: <552cad388461c04dc635c9e29128339f@localhost>
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

Oh well, you're right.. there are still some CF/IDE adapters which do not
support DMA. I'll guess this is the problem then, so I'll return it to the
shop.

Best regards,
Philipp

