Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYBXRKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYBXRKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYBXRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:09:56 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38772 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbYBXRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:09:55 -0500
Date: Sun, 24 Feb 2008 16:59:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] DIGIEPCA:  Remove long-obsolete digiepca driver.
Message-ID: <20080224165955.790d1360@core>
In-Reply-To: <alpine.LFD.1.00.0802241010040.7616@localhost.localdomain>
References: <alpine.LFD.1.00.0802241010040.7616@localhost.localdomain>
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

On Sun, 24 Feb 2008 10:12:41 -0500 (EST)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> 
> Given that the removal of this driver has been under discussion for
> over a year:
> 
>   http://lkml.org/lkml/2006/10/26/231
> 
> it would seem time to get rid of it.

NAK - not until a replacement driver supporting the hardware is merged.

Alan
