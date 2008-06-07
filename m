Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYFGOQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYFGOQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYFGOQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:16:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbYFGOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:16:08 -0400
Date: Sat, 7 Jun 2008 14:59:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: pppd and 2.6.25 serial driver
Message-ID: <20080607145952.42a1bd3d@core>
In-Reply-To: <20080607151054.5d2b76e0@boulder.homenet>
References: <20080601215621.256db193@boulder.homenet>
	<20080605222355.be299fff.akpm@linux-foundation.org>
	<20080606110928.2e034c26@core>
	<20080607151054.5d2b76e0@boulder.homenet>
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

> Who uses internet dial-up these days?  However, it could be something

Quite a lot of people, especially outside the UK.

> odd about my hardware, which is a laptop using via chipsets, but it
> is also ppp specific, as I can receive faxes with a fax modem using the
> 2.6.25 serial driver.
> 
> Anyway, I have checked with the serial driver in the latest 2.6.26
> (2.6.26-rc5) and that still works fine with ppp.

Good to know.
