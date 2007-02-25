Return-Path: <linux-kernel-owner+w=401wt.eu-S1751106AbXBYU5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbXBYU5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXBYU5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:57:04 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34801 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbXBYU5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:57:03 -0500
Message-ID: <45E1F81C.3050504@garzik.org>
Date: Sun, 25 Feb 2007 15:57:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH]: Add id_to_dma_mode function for printing DMA modes
References: <20070220180159.632d33bc@localhost.localdomain>
In-Reply-To: <20070220180159.632d33bc@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Also export dev_disable as this is needed by drivers doing slave decode
> filtering, which will follow shortly
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied



