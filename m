Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYI1WX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYI1WX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 18:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYI1WXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 18:23:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36896 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752813AbYI1WXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 18:23:50 -0400
Date: Sun, 28 Sep 2008 23:23:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Li" <lkml@chrisli.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: irq 19: nobody cared
Message-ID: <20080928232333.34c87ed0@lxorguk.ukuu.org.uk>
In-Reply-To: <70318cbf0809191613u19ecc807j8911bc9a4ada50a2@mail.gmail.com>
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	<20080919233808.64aa7539@lxorguk.ukuu.org.uk>
	<70318cbf0809191613u19ecc807j8911bc9a4ada50a2@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any thing I can do to help to identify the problem?

Best is probably to file a bug report in bugzilla.kernel.org. These sort
of things take a bit of pinning down and are often BIOS problems.
