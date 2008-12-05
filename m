Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYLETei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYLETei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYLETeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:34:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752641AbYLETea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:34:30 -0500
Date: Fri, 5 Dec 2008 19:34:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081205192755.GA27712@ioremap.net>
References: <20081205180350.GA25236@ioremap.net>
	<20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	<ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
	<20081205192755.GA27712@ioremap.net>
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

> I can not run bisect, since reboot requires vnc and I'm far from fast
> channel. Build of the fresh tree with existing config takes almost
> one hour, but it should not be a major problem.
> 
> I can do bisection after the weekend, but can test some changes before
> machine froze with unsuccessful patch.

I really have no idea what you are seeing so short of a bisect I've
nothing to suggest.
