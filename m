Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYJQTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYJQTsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYJQTsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:48:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755561AbYJQTsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:48:02 -0400
Date: Fri, 17 Oct 2008 20:47:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017204723.15114eaa@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017174657.GH2221@kroah.com>
References: <20081016002509.GA25868@kroah.com>
	<20081016124943.GE23630@cs181140183.pp.htv.fi>
	<20081016151748.GA31075@kroah.com>
	<20081016164602.GA22554@cs181140183.pp.htv.fi>
	<20081017034717.GA28188@kroah.com>
	<20081017064751.GE22554@cs181140183.pp.htv.fi>
	<20081017075544.GB4850@kroah.com>
	<f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
	<20081017174657.GH2221@kroah.com>
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

> And that's my point here, do we want to change the current numbering
> scheme as people have expressed annoyances of the current one.

But any new scheme will be just as annoying to someone and it messes up
existing documentation, understanding and risks breaking third party
tools.

Is it really worth the hassle, plus we'll have to change again if we use
date/times because once we are shipping Linux out to Alpha Centauri with
colonists there will be serious problems trying to compute the effect of
tau on release numbering ...

(Ducks)

Alan
