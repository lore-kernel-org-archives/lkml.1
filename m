Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXIBKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXIBKcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXIBKcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 06:32:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33688 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932554AbXIBKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 06:32:06 -0400
Date: Sun, 2 Sep 2007 11:40:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: patrizio.bassi@gmail.com
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
Message-ID: <20070902114032.7dbfb21a@the-village.bc.nu>
In-Reply-To: <46D89429.7080802@gmail.com>
References: <46D132C5.5000803@gmail.com>
	<6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
	<46D8921E.3010304@gmail.com>
	<46D89429.7080802@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i've been out for a week, but found no notice, did i lost any email or
> no activity on this issue?

I tagged it onto the obscure IDE report pile. It doesn't contain any
really useful information and its probably not an IDE layer bug as of
itself. But its on the todo list for further investigation and to see if
patterns emerge
