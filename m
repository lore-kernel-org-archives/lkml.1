Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXJKNSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXJKNSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXJKNRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:17:52 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38800 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbXJKNRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:17:51 -0400
Message-ID: <470E2220.6040504@aitel.hist.no>
Date: Thu, 11 Oct 2007 15:16:16 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: philipp@igowo.de
CC: linux-kernel@vger.kernel.org
Subject: Re: IDE DMA doesn't work with pata_via and compact flash card
References: <20071011111911.0d322827@the-village.bc.nu> <f3e1edf0cde8141d7145411c4ae3212d@localhost>
In-Reply-To: <f3e1edf0cde8141d7145411c4ae3212d@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

philipp@igowo.de wrote:
>> Does your CF/IDE adapter support DMA ?
>>     
>
> Thank you for your answer :)
>
> I thought CF/IDE adapters are mainly electrical adapters.. I've never seen
> one which explicitly states the modes it supports. On the other hand it
> says on the package: "Vista compatible" (whatever that means)
>
> Is there some way I can figure it out? I'll have a deeper look on the
> datasheet when I'm home again later, but I'm rather sure there wasn't
> anything mentioning supporting data transfer modes..
>   
Some take care to document this. I checked dma capability
before bying mine. mini-itx.com seems to get this right.

Helge Hafting
