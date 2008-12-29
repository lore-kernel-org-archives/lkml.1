Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYL2XeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYL2XeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYL2XeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:34:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50757 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbYL2XeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:34:08 -0500
Date: Mon, 29 Dec 2008 23:33:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: 7eggert@gmx.de
Cc: for.poige+linux@gmail.com, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: > I even didn't have a backtrace.
Message-ID: <20081229233347.78d488b0@lxorguk.ukuu.org.uk>
In-Reply-To: <E1LHNit-0001cP-EQ@be1.7eggert.dyndns.org>
References: <bOpT3-2LN-13@gated-at.bofh.it>
	<bOpT3-2LN-15@gated-at.bofh.it>
	<bOpT3-2LN-11@gated-at.bofh.it>
	<E1LHNit-0001cP-EQ@be1.7eggert.dyndns.org>
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

One place to hide stuff is the upper areas of video ram as a lot of
videocards don't clear the ram on a crash/reboot. I used to use a 3Dfx
32Mb card as a buffer with good effect.

Alan
