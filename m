Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbXFVJGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbXFVJGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXFVJGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:06:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36749 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698AbXFVJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:06:41 -0400
Date: Fri, 22 Jun 2007 10:10:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
Message-ID: <20070622101019.0f3b0d3d@the-village.bc.nu>
In-Reply-To: <1182483586.10524.33.camel@shinybook.infradead.org>
References: <20070621235211.GH23017@stusta.de>
	<1182483586.10524.33.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 11:39:45 +0800
David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2007-06-22 at 01:52 +0200, Adrian Bunk wrote:
> > Users should use the libata based drivers for SATA drives.
> 
> NAK. Not all IDE drivers are converted yet. Not even all the relatively
> common ones.

All the common SATA ones are. Just the PowerPC people are falling behind.
Really we should obsolete powerpc instead ;)

Alan
