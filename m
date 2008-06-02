Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYFBTfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYFBTfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYFBTe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:34:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51762 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbYFBTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:34:55 -0400
Date: Mon, 2 Jun 2008 20:19:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602201911.1a48cc83@core>
In-Reply-To: <1212434648.8810.10.camel@shinybook.infradead.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	<1212421611.16924.246.camel@pmac.infradead.org>
	<20080602165649.01c2c680@core>
	<1212434648.8810.10.camel@shinybook.infradead.org>
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

> Don't forget to document how people are _supposed_ to use the v4l api
> from userspace, though.

Correct but those methods are not part of the V4L2 API and have not been
for some considerable time. Removing it from the Kbuild file would simply
break even more stuff. 



