Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXBVQLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXBVQLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXBVQLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:11:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44537 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbXBVQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:11:09 -0500
Date: Thu, 22 Feb 2007 17:14:40 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata-piix ACPI errors
Message-ID: <20070222171440.26004a28@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.SOC.4.64.0702221614540.20840@math>
References: <Pine.SOC.4.64.0702221525480.20840@math>
	<20070222150641.037f7fbe@lxorguk.ukuu.org.uk>
	<Pine.SOC.4.64.0702221614540.20840@math>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It shows UDMA/100 for HDD and UDMA/33 for DVD-ROM. Visual inspection 
> confirms that this is correct - DVD-ROM has 40-pin cable and HDD has 
> 80-pin one. So at least the result is not wrong.

Ok sorry didn't realise this one had a genuine 40pin cable case, forgot
the -mm message about limiting is only in -mm 8(

