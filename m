Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYLCXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYLCXI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLCXIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:08:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45631 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753876AbYLCXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:08:17 -0500
Date: Wed, 3 Dec 2008 23:08:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081203230820.4473a162@lxorguk.ukuu.org.uk>
In-Reply-To: <1228344292.6993.27.camel@lappy.spacevs.com>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	<20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	<1228268657.6679.4.camel@lappy.spacevs.com>
	<20081203124252.GD11807@mail.local.tull.net>
	<1228344292.6993.27.camel@lappy.spacevs.com>
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

> The children are pre-forked, so the overhead is in the setup... then
> when the app recieves a request, it sets the child's uid to the uid of
> the website, and then passes the request to the child, which, now, the
> child is running as the website owner.

But the child process may already have been trojanned by a previous user
so it gains you nothing.

> It is more secure then just doing nothing.

I'm not convinced. Not remotely.

