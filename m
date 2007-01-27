Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbXA0NcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbXA0NcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 08:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXA0NcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 08:32:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45811 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbXA0NcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 08:32:05 -0500
Date: Sat, 27 Jan 2007 13:43:46 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ahci: Marvell 6145 SATA support (preliminary)
Message-ID: <20070127134346.71d8ecf4@localhost.localdomain>
In-Reply-To: <20070127034023.GA25959@havoc.gtf.org>
References: <20070127034023.GA25959@havoc.gtf.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Were it not for the PATA and interrupt storm bits, I would say that
> Marvell 6145 works with a simple PCI ID addition.


The 6101 driver should drive the 6145 pata port via the legacy registers
