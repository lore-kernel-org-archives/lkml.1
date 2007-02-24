Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXBWXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXBWXOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXBWXOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:14:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933260AbXBWXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:14:42 -0500
Date: Sat, 24 Feb 2007 00:18:29 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: <Tom.Morrison@Verizon.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Problems with init of Marvell PCI Express SATA Card
Message-ID: <20070224001829.2b444773@lxorguk.ukuu.org.uk>
In-Reply-To: <CJEDIOAEPEPAEFLDLKIBAEJLCDAA.Tom.Morrison@Verizon.net>
References: <CJEDIOAEPEPAEFLDLKIBAEJLCDAA.Tom.Morrison@Verizon.net>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What am I doing wrong? Do I need to have 
> the PCI ids in the kernel match identically 
> what is on pci express sata card device?

And driver support which may or may not be present depending on the card.

Alan
