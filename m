Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXLaQKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXLaQKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXLaQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:10:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51893 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbXLaQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:10:09 -0500
Date: Mon, 31 Dec 2007 16:01:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20071231160140.579f0fb2@the-village.bc.nu>
In-Reply-To: <200712311659.14847.mb@bu3sch.de>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
	<20071231144255.GB13803@does.not.exist>
	<64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
	<200712311659.14847.mb@bu3sch.de>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd say the practical advantage to the user would be almost zero.
> Which distribution is going to enable this option and defacto
> banning external modules?

It would be a real nuisance for developing code let alone for using it.
The entries are currently far bigger than is needed and fixing that would
be much more productive.

Alan
