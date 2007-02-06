Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXBFOrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXBFOrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXBFOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:47:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36369 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbXBFOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:47:10 -0500
Date: Tue, 6 Feb 2007 15:00:06 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] pata_acpi driver
Message-ID: <20070206150006.1403ff5d@localhost.localdomain>
In-Reply-To: <b6fcc0a0702060541s4f14f439xe448574ba7e318a5@mail.gmail.com>
References: <20070206134623.0dc3f566@localhost.localdomain>
	<b6fcc0a0702060541s4f14f439xe448574ba7e318a5@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	in_params[2].type = ACPI_TYPE_BUFFER;
> > +	in_params[2].buffer.length = 512;
> > +	in_params[1].buffer.pointer = (u8 *)ap->device[1].id;
> 
> Must be a typo. [2]

Indeed it is - thanks.

Alan
