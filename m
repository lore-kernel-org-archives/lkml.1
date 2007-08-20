Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbXHTWxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbXHTWxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXHTWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:60137 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbXHTWwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:30 -0400
Message-Id: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:06 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Subject: [patch 00/14] More patches to convert from struct class_device to struct device
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

[patch 01/14] block/paride
[patch 02/14] block/pktcdvd
[patch 03/14] block/aoechr
[patch 04/14] drivers/macintosh
[patch 05/14] cosa sync driver
[patch 06/14] MTD/mtdchar
[patch 07/14] IDE/ide-tape
[patch 08/14] DMA engine
[patch 09/14] SPI
[patch 10/14] USB core
[patch 11/14] USB host
[patch 12/14] TI flash media
[patch 13/14] UCB1x00
[patch 14/14] ISDN capi
