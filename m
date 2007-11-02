Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXKBQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXKBQDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbXKBQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:03:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32802 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756228AbXKBQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:03:15 -0400
Date: Fri, 2 Nov 2007 16:04:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: IRDA irnet_ppp driver
Message-ID: <20071102160418.629f59c7@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A long long time ago, in a land so far away that people walked
upside down, there lived a wizard called Paul. Paul was a very
powerful wizard and created the ppp daemon from the darkness.
The pppd daemon was good and hard working, but not very clever.
It thought that everything it conneected to was a terminal.

Paul saw that this was a bad thing, and when it was old enough he
sent the daemon to school and taught it about the generic ppp layer
and about the "notty" option.

Someone who actually has IRDA and still uses it (do they exist ?) needs to
do the relevant work to the irda FIR code.

Alan
