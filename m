Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbXG3Mxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbXG3Mxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXG3Mxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:53:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42223 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753277AbXG3Mxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:53:32 -0400
Date: Mon, 30 Jul 2007 13:57:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Sriram, Kannan" <ksriram@ti.com>
Cc: "Midhun A" <midhunagni@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>,
       <linux-mtd@lists.infradead.org>
Subject: Re: Testing of CPRM on SD Card
Message-ID: <20070730135723.4e5338b4@the-village.bc.nu>
In-Reply-To: <0A50DBE80DD6674E94F7269DC964A7B6440EDA@dbde01.ent.ti.com>
References: <e1d5030b0707280108v236cc522m454c58e1044f1996@mail.gmail.com>
	<0A50DBE80DD6674E94F7269DC964A7B6440EDA@dbde01.ent.ti.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 11:20:58 +0530
"Sriram, Kannan" <ksriram@ti.com> wrote:

> 
> Midhun,
> 
>  There is no open-source implementation of CPRM (SD-Audio/ SD-Bind
> standards). So first of all, you need to license keys from 4C (device
> keys, media keys etc) and do your own implementation.

Also remember that if you do your own implementation in the kernel you
will be required to publish the source code under the GPL and that will
not be permitted with the CPRM licensing. Thus you will need to do all
the work in user space.

