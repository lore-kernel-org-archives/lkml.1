Return-Path: <linux-kernel-owner+w=401wt.eu-S1422871AbXBAO3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871AbXBAO3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422873AbXBAO3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:29:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422871AbXBAO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:29:29 -0500
Date: Thu, 1 Feb 2007 14:41:45 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Sergei Organov <osv@javad.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201144145.26b0b90e@localhost.localdomain>
In-Reply-To: <873b5q2c0z.fsf@javad.com>
References: <20070130012904.GA9617@kroah.com>
	<ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com>
	<87fy9r2ixc.fsf@javad.com>
	<20070201054644.GD5979@kroah.com>
	<873b5q2c0z.fsf@javad.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 3. Vendor driver is rather close to the generic one being in the kernel,
>    so maybe it's better to improve generic one instead of adding yet
>    another driver to the tree.

Firstly can you post a patch which adds the relevant identifiers to the
current pcmcia serial driver so that 115,200 works but nothing higher.
After that I'd like to take a look at the needed changes for higher speed
support using the 2.6.20-mm work which adds arbitary speed support.

Alan
