Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbXGCPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbXGCPkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXGCPkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:40:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33074 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374AbXGCPkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:40:14 -0400
Message-ID: <468A6DDB.706@garzik.org>
Date: Tue, 03 Jul 2007 11:40:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
References: <20070703161002.1576c39d@the-village.bc.nu>
In-Reply-To: <20070703161002.1576c39d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The HPT343/345 (aka 363) is a bit of a warped device. For many setups you
> need to access the other registers via BAR4 offsets. PIO is now rock
> solid, DMA isn't. Unfortunately the drivers/ide hpt34x driver is
> completely broken so doesn't help further debug.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

OK but doesn't apply


