Return-Path: <linux-kernel-owner+w=401wt.eu-S966279AbXIBMaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966279AbXIBMaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964987AbXIBM3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:29:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54665 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965480AbXIBM3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:29:49 -0400
Date: Sun, 2 Sep 2007 13:38:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "n" <xellos@bluebottle.com>
Cc: <patrizio.bassi@gmail.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: libata / pata drivers and smart , pata_via . pata_pdc202xx_old
Message-ID: <20070902133800.7c188e98@the-village.bc.nu>
In-Reply-To: <200709021158.l82BwCcR013983@mi0.bluebottle.com>
References: <200709021158.l82BwCcR013983@mi0.bluebottle.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007 04:58:11 -0700
"n" <xellos@bluebottle.com> wrote:

> is it possible to get the new libata drivers (pata_via . pata_pdc202xx_old) 
> to support smart?
> i was looking at smartcrl -a and it says Device does not support SMART even 
> though it does.

They support smart. You may need a newer smartctl or to use different
options
