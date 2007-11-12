Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbXKLTss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbXKLTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXKLTsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:48:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35080 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687AbXKLTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:48:40 -0500
Date: Mon, 12 Nov 2007 19:48:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ron Yorgason" <yorgasor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
Message-ID: <20071112194806.4cb9c688@the-village.bc.nu>
In-Reply-To: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
References: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the kernel), performance is pretty abysmal.  What would it take to get
> proper DMA support?  Is it an architecture problem, in that this
> doesn't use the normal IDE PCI driver?  Is it a lack of documentation
> on card specs?  What can I do to help?

Persuade Delkin to provide specifications either publically or under NDA
(but allowing a GPL source code driver) with one of the ATA developers.

For a fairly typical SFF style controller it shouldn't take long to
produce a test driver.

Alan
