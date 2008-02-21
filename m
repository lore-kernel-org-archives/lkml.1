Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbYBUPZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbYBUPZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYBUPZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:25:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47668 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752309AbYBUPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:25:19 -0500
Date: Thu, 21 Feb 2008 15:15:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080221151549.0fa72422@core>
In-Reply-To: <47BD9721.70907@davidnewall.com>
References: <47B30291.2040905@davidnewall.com>
	<20080214050211.GB1432@kroah.com>
	<47B40918.20206@davidnewall.com>
	<20080214121026.16a9c510@core>
	<47B482B4.9010208@davidnewall.com>
	<20080214193637.5df1c205@core>
	<47BD9721.70907@davidnewall.com>
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

> developing is entirely wrong.  Oh well.  Mind you, providing a
> write_room function is NOT a real solution; it merely reduces the
> condition to a usually-winnable race.  (Ironically, when I back-ported
> the 2.6 driver, I excluded its new write_room function.  Mistake.)

What race do you see left ?

