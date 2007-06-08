Return-Path: <linux-kernel-owner+w=401wt.eu-S970740AbXFHQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970740AbXFHQhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXFHQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:36:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50152 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S969625AbXFHQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:36:40 -0400
Date: Fri, 8 Jun 2007 17:41:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
Message-ID: <20070608174150.6f892f83@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706081226110.2683@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
	<20070608163018.636b74d1@the-village.bc.nu>
	<Pine.LNX.4.64.0706081125390.30491@localhost.localdomain>
	<20070608164830.54436f6b@the-village.bc.nu>
	<Pine.LNX.4.64.0706081144300.31863@localhost.localdomain>
	<20070608165746.30fb5bd9@the-village.bc.nu>
	<Pine.LNX.4.64.0706081211280.1504@localhost.localdomain>
	<20070608172422.55f3db5f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081226110.2683@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, i'll defer to your experience.  but can we at least apply my patch
> to protect console_struct.h from multiple inclusion?  that one really
> *is* annoying.

I've not seen that one but send it - multiple inclusion is a different
problem altogether
