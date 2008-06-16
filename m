Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYFPUP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYFPUP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYFPUPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:15:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51956 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556AbYFPUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:15:51 -0400
Date: Mon, 16 Jun 2008 20:58:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
In-Reply-To: <4856C795.2050007@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
	<4856C6C8.6060506@garzik.org>
	<4856C795.2050007@garzik.org>
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

> There is no reason why firmware must be artificially separated into 
> firmware/

It seems a good step towards kicking it all out of the kernel tree into
user space where it belongs.

Alan
