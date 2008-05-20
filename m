Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbYETTGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbYETTGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbYETTFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:05:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34318 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763682AbYETTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:05:42 -0400
Date: Tue, 20 May 2008 19:53:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
 logic
Message-ID: <20080520195309.0f429208@core>
In-Reply-To: <20080520172330.GC11666@kroah.com>
References: <20080519144557.19326.74313.stgit@core>
	<20080519165049.GA19896@kroah.com>
	<20080520015241.bd66fff0.akpm@linux-foundation.org>
	<20080520172330.GC11666@kroah.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But if a great mountain of tty- and/or char-related patches is
> > forthcoming, that mountain will probably have a depencency upon your
> > tree.  And that's OK too, as long as you don't go and bugger up your
> > tree and get it dropped from linux-next!  Because if that happens I'll
> > need to temporarily drop all the dependent patches and remember to
> > restore them, which is always a bit sad.
> 
> That's up to Alan, I don't know what he has brewing for 2.6.27.

I'm trying to work in sensible testable stages. Whats brewing at the
moment is thoughts tty_get() and tty_put() but I don't have a bootable
usable tree for that yet and there is work to be done.

