Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZA2QFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZA2QFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZA2QFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:05:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39219 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbZA2QFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:05:42 -0500
Date: Thu, 29 Jan 2009 16:06:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pazzo Da Legare <pazzodalegare@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NEWBIE: how to change serial device<->port association
Message-ID: <20090129160602.235840c2@lxorguk.ukuu.org.uk>
In-Reply-To: <1a26b4920901290616r40c1edd0tec62d0e6bf24dc9@mail.gmail.com>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
	<20090129134537.12121834@lxorguk.ukuu.org.uk>
	<1a26b4920901290616r40c1edd0tec62d0e6bf24dc9@mail.gmail.com>
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

> The hws have a different combination of kind serials and I would like
> to present the same ttyS* to applications. I need to have different

By having multiple different kernels for the different systems ? That
sounds like a really really complicated way to go about the problem when
you could just add a config file to your application.

