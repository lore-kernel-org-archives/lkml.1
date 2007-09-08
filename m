Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXIHNjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXIHNjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 09:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXIHNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 09:39:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34412 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXIHNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 09:39:43 -0400
Date: Sat, 8 Sep 2007 14:47:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070908144758.37ab3c76@the-village.bc.nu>
In-Reply-To: <200709080652.02614.a1426z@gawab.com>
References: <200709080652.02614.a1426z@gawab.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I once sent a patch to make libata a submenu of scsi.

Which is wrong

Nakked-by: Alan Cox <alan@redhat.com>

The general comments about moving this stuff around and making it clearer
what sd/sr etc are nowdays are good but hiding libata under SCSI will
cause even more confusion than it cures

