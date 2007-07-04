Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXGDOR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXGDOR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXGDORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:17:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49255 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758750AbXGDORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:17:47 -0400
Date: Wed, 4 Jul 2007 15:23:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
Message-ID: <20070704152359.1ad8d194@the-village.bc.nu>
In-Reply-To: <20070704132930.GB10904@one.firstfloor.org>
References: <20070703185116.59c8f5f5@the-village.bc.nu>
	<p73k5tg2uj9.fsf@bingen.suse.de>
	<20070704131746.4bbe4d0e@the-village.bc.nu>
	<20070704130258.GA10904@one.firstfloor.org>
	<20070704141819.01a357fa@the-village.bc.nu>
	<20070704132930.GB10904@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007 15:29:30 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > You could probably reliably map "hda/b/c/d" initially with some kind of
> > forwarder providing nobody hot plugged them.  Just not sure I see the
> 
> PATA hotplug? 
> 
> SATA systems typically already use /dev/sda*, it just applies to PATA.

We support PATA warm plugging sort of already and it'll go further in
time. Mostly this is relevant to laptops
