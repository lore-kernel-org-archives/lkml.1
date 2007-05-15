Return-Path: <linux-kernel-owner+w=401wt.eu-S934260AbXEOLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbXEOLoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbXEOLoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:44:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35237 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757279AbXEOLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:44:04 -0400
Date: Tue, 15 May 2007 12:48:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Kuther <gimpel@sonnenkinder.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070515124836.1ce42b0f@the-village.bc.nu>
In-Reply-To: <20070515133555.0111c063@SiRiUS.home>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<20070515123132.2e596d69@the-village.bc.nu>
	<20070515133555.0111c063@SiRiUS.home>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I already tried pata_it821x and it failed to recognize the second
> harddisk hdf. I use the controller only for additional harddrives, no
> RAID, no cd-rom.

Logs from that would be most helpful as I am maintaining the pata_it821x
driver.

Alan

