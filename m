Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbXA3WbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbXA3WbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXA3WbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:31:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34259 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbXA3WbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:31:19 -0500
Date: Tue, 30 Jan 2007 22:43:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130224328.7f6a8850@localhost.localdomain>
In-Reply-To: <adaodogqpmx.fsf@cisco.com>
References: <20070130012904.GA9617@kroah.com>
	<ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com>
	<adaodogqpmx.fsf@cisco.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Like Jeff said, many of these are quite old.
> 
> OK, but why isn't your army of volunteers fixing them?

One of the problems if lack of hardware. It's very hard to fix a
prehistoric serial driver if you don't have an ISA bus box with the
needed slot let alone the card.

And why bother - its hardware that works on all the cases that matter

> Device Class", but nothing happens when I plug it into my Linux box.
> I assume the device class is specified as part of the USB spec...

UVC is "interesting", in a bad kind of interesting sort of way. See
http://developer.berlios.de/projects/linux-uvc however

