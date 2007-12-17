Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXLQNMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXLQNMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXLQNMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:12:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45549 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754279AbXLQNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:12:21 -0500
Date: Mon, 17 Dec 2007 13:05:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Filippos Papadopoulos" <psybases@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20071217130523.7e9c88bb@the-village.bc.nu>
In-Reply-To: <20071217031841.f483e5ac.akpm@linux-foundation.org>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<20071217031841.f483e5ac.akpm@linux-foundation.org>
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

> initio doesn't seem to have a maintainer...
> 
> Are you able to identify any earlier kernel which worked OK?
> 
> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> for that device we can take a look.

If I remember rightly the fixes for this went into the scsi tree a couple
of months ago. The patch is in the -mm tree as well. No idea why its
gotten stuck as an obvious one liner.

Alan
