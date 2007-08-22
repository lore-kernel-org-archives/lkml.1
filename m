Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbXHVPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbXHVPZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbXHVPZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:25:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59729 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759856AbXHVPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:25:45 -0400
Date: Wed, 22 Aug 2007 16:33:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Xu Yang" <risingsunxy@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how is the boot process of the multicore system
Message-ID: <20070822163354.4b57f501@the-village.bc.nu>
In-Reply-To: <ab40e9c0708220753l1861cde2wccb58ba931f04b2c@mail.gmail.com>
References: <ab40e9c0708220753l1861cde2wccb58ba931f04b2c@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 16:53:41 +0200
"Xu Yang" <risingsunxy@googlemail.com> wrote:

> Hi everyone,
> 
> I am just wondering how is the boot process of the multicore system exactly.
> let's say there are 4 cores , what is the booting sequence? and how
> does linux realise the booting process?

For PC type systems read the Intel MP 1.4 specification, available on the
intel developer web site
