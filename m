Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYFPUjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYFPUjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYFPUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:38:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59780 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753476AbYFPUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:38:51 -0400
Date: Mon, 16 Jun 2008 21:21:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616212111.406f9c96@lxorguk.ukuu.org.uk>
In-Reply-To: <4856CB61.6030202@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
	<4856C6C8.6060506@garzik.org>
	<4856C795.2050007@garzik.org>
	<20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
	<4856CB61.6030202@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Extracting the firmware:  good
> 
> Scattering a /single/ driver across multiple directories in the kernel 
> tree:  bad

I'd equally argue that putting all the firmware in one place is more
logical than smearing it around the tree.

Whatever - someone can have the 'where do we put it debate' and git does
renames.
