Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbYF3RX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbYF3RX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYF3RXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:23:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45471 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbYF3RXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:23:18 -0400
Date: Mon, 30 Jun 2008 18:05:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: JosephChan@via.com.tw, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       geert@linux-m68k.org
Subject: Re: [PATCH 12/13] viafb: via_i2c.c, via_i2c.h, viamode.c, viamode.c
Message-ID: <20080630180538.51fc993d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080630154348.GF21835@fluff.org.uk>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E78AA@exchtp03.taipei.via.com.tw>
	<20080630154348.GF21835@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like an attempt at re-doing the already extant i2c gpio
> algorithm. Either export via gpiolib and use the i2c-gpio adapter or
> use the i2c bit-banging algorithm.

Agreed - but this can be done a lot more easily after a merge.


Alan
