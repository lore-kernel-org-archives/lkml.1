Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXGIWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXGIWCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbXGIWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:02:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34316 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755403AbXGIWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:02:09 -0400
Date: Mon, 9 Jul 2007 23:06:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Adrian Bunk <bunk@stusta.de>, Zhang Rui <rui.zhang@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
Message-ID: <20070709230623.417cb0df@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
References: <20070709145755.GD3492@stusta.de>
	<20070709174544.2a6b7067@the-village.bc.nu>
	<Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 20:46:20 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jul 9 2007 17:45, Alan Cox wrote:
> >
> >> This patch contains the scheduled removal of the ACPI procfs interface.
> >
> >What part of "we do not gratuitously break user space interfaces" is so
> >hard for people to understand.
> 
> Generally I am with you on that, but if everyone keeps on using /proc --
> and I do[*] -- we will never get rid of it.

And why do we need to get rid of it ?
