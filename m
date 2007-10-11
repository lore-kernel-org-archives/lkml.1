Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXJKWWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXJKWWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXJKWWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:22:05 -0400
Received: from pear.igowo.de ([81.95.0.210]:60146 "EHLO pear.igowo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbXJKWWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:22:04 -0400
Message-ID: <470EA1FC.4040604@igowo.de>
Date: Fri, 12 Oct 2007 00:21:48 +0200
From: Philipp Wollermann <philipp@igowo.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: IDE DMA doesn't work with pata_via and compact flash card
References: <20071011111911.0d322827@the-village.bc.nu> <f3e1edf0cde8141d7145411c4ae3212d@localhost> <470E2220.6040504@aitel.hist.no>
In-Reply-To: <470E2220.6040504@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:
> philipp@igowo.de wrote:
>>> Does your CF/IDE adapter support DMA ?
>>
>> Is there some way I can figure it out? I'll have a deeper look on the
>> datasheet when I'm home again later, but I'm rather sure there wasn't
>> anything mentioning supporting data transfer modes..
>>   
> Some take care to document this. I checked dma capability
> before bying mine. mini-itx.com seems to get this right.

I have returned the adapter card, it indeed didn't support DMA (I 
checked the pins on the board, pin 21 and 29 are necessary for DMA 
support and they weren't wired). I bought a new one which explicitly 
supports DMA and will report when it ships. :)

Best regards,
Philipp
