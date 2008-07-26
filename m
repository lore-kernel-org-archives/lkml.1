Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYGZQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYGZQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYGZQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:14:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35744 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbYGZQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:14:51 -0400
Date: Sat, 26 Jul 2008 16:52:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tim@physik3.uni-rostock.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nwflash: fix build errors and warning
Message-ID: <20080726165258.2dacff67@lxorguk.ukuu.org.uk>
In-Reply-To: <20080726150155.GA3562@localhost.localdomain>
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org>
	<20080726141808.GB8871@flint.arm.linux.org.uk>
	<20080726150155.GA3562@localhost.localdomain>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry. I'm preparing cross compiler. But this patch should fix this
> problem.

nwflash is a flash programming driver. Any changes to it should be
rigorously tested or obviously correct because you can brick a netwindup
if you get it wrong.

Alan
