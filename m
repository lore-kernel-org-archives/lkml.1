Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZARS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZARS62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZARS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:58:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45982 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbZARS6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:58:08 -0500
Date: Sun, 18 Jan 2009 18:58:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Wagner <daw@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
Message-ID: <20090118185823.0aa7239f@lxorguk.ukuu.org.uk>
In-Reply-To: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
References: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (I can't set libata.force=1.5Gbps as a kernel argument because on my
> Fedora kernel, libata is loaded as a module rather than built into the
> kernel.  I can't run "modprobe libata force=1.5Gbps" by hand because
> I've got SATA drives, so the libata module is automatically loaded before
> I get shell access.)

Best to ask on the Fedora lists for fedora specific config help. If I
remember rightly you need to update the module options in the initrd...

Alan
