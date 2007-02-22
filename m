Return-Path: <linux-kernel-owner+w=401wt.eu-S1946004AbXBVODP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946004AbXBVODP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXBVODP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:03:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52388 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946004AbXBVODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:03:14 -0500
Date: Thu, 22 Feb 2007 15:06:41 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata-piix ACPI errors
Message-ID: <20070222150641.037f7fbe@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.SOC.4.64.0702221525480.20840@math>
References: <Pine.SOC.4.64.0702221525480.20840@math>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 15:29:42 +0200 (EET)
Meelis Roos <mroos@linux.ee> wrote:

> Testbooted 2.6.21-rc1+todays git on a PC with Intel 845 chipset and PATA 
> HDD. Works fine but I now have these ACPI errors in dmesg, maybe someone 
> is interested:

Not in those but again note that the cable detection is broken 

> ata2.00: ATAPI, max UDMA/33
