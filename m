Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXBDRfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXBDRfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXBDRfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:35:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57085 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752454AbXBDRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:35:12 -0500
Date: Sun, 4 Feb 2007 17:48:00 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Patrick Ale" <patrick.ale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: More pata_ stuff
Message-ID: <20070204174800.770c4d4a@localhost.localdomain>
In-Reply-To: <8d158e1f0702040801g47e6f4f3mfd37da6aa13d9e0e@mail.gmail.com>
References: <8d158e1f0702040801g47e6f4f3mfd37da6aa13d9e0e@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately the controller doesn't get detected on boot time, the
> old IDE drivers do work and see the controller as a PIIX4 chipset,
> which is correct.

Please provide kernel version, an lspci -vvxxx, the actual type of
controller if you know it (if not the lspci will show it) and your .config

Remember that you'll beed both scsi disk and the relevant pata driver
support to detect your disks.
