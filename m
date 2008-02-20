Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbYBTOcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbYBTOcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYBTOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:32:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54639 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753663AbYBTOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:32:46 -0500
Date: Wed, 20 Feb 2008 14:23:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Gregory Nietsky <gregory@networksentry.co.za>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080220142312.2b5fa44f@core>
In-Reply-To: <47BC370F.3000705@imap.cc>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
	<20080217195235.GN14588@uranus.ravnborg.org>
	<20080218045209.GA15141@kroah.com>
	<p73zltyxy9q.fsf@bingen.suse.de>
	<20080219085033.GA1775@uranus.ravnborg.org>
	<47BAA072.9050601@networksentry.co.za>
	<47BC370F.3000705@imap.cc>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mISDN has two problems, which are of course interrelated:
> 
> a) complete lack of documentation for the in-kernel driver interface
>     (equivalent of Documentation/isdn/INTERFACE)
> 
> b) still doesn't support all the hardware isdn4linux supports.
> 
> As long as those problems aren't solved, the old stuff cannot be removed.
> Perhaps merging the current state of mISDN into the -mm tree would help
> with this. Perhaps not.

It should get put into the -mm tree so it can be worked on, and if they
won't do that it should probably get binned and people them know what is
going on and can fix the existing isdn code.
