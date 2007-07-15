Return-Path: <linux-kernel-owner+w=401wt.eu-S1762455AbXGORdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455AbXGORdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbXGORcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:32:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40843 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758624AbXGORcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:32:51 -0400
Date: Sun, 15 Jul 2007 18:39:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i386: pata_cs5520 does not work
Message-ID: <20070715183924.0a6c992b@the-village.bc.nu>
In-Reply-To: <20070716.014115.193701589.takada@mbf.nifty.com>
References: <20070716.014115.193701589.takada@mbf.nifty.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 01:41:15 +0900 (JST)
TAKADA Yoshihito <takada@mbf.nifty.com> wrote:

> Hi.
> I update to 2.6.22.1 from 2.6.21.5. And PC cannot mount /.
> It seems pata_cs5520 does not find IDE controller.
> (I don't have serial cable for CS5520 board now. I cannt read
> boot messages.)
> 2.6.21 is OK.
> In 2.6.22, IDE driver is OK.
> Is any information necessary?

I'll take a look at this next week. Can you send me a dmesg of the
working case and an lspci -vvxxx

Thanks
Alan
