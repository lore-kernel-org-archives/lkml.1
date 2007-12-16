Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbXLPVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbXLPVIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbXLPVH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:07:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47977 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755972AbXLPVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:07:58 -0500
Date: Sun, 16 Dec 2007 21:01:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: devzero@web.de
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Matt_Domsch@dell.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Message-ID: <20071216210122.23aa9cb6@the-village.bc.nu>
In-Reply-To: <49547705@web.de>
References: <49547705@web.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But that is not the point. Problem is not widely known, likely happens
> > with very old BIOSes and people who use those systems should be
> > knowing more than simply booting back to Win98.
> 
> i don`t see any relation to what a user knows and what kind of system of what age he is using.

Its much much uglier than that alas. All the cases I've traced down have
been buggy bioses on add in cards not the system BIOS - the edd hang
actually moved with the controller card.

So it is useful to know.
