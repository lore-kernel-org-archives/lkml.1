Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYFBUBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYFBUBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYFBUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:01:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34718 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYFBUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:01:36 -0400
Date: Mon, 2 Jun 2008 20:45:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602204554.1d0f0809@core>
In-Reply-To: <1212436778.8810.27.camel@shinybook.infradead.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	<1212421611.16924.246.camel@pmac.infradead.org>
	<20080602165649.01c2c680@core>
	<1212434648.8810.10.camel@shinybook.infradead.org>
	<20080602201911.1a48cc83@core>
	<1212436778.8810.27.camel@shinybook.infradead.org>
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

On Mon, 02 Jun 2008 20:59:38 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2008-06-02 at 20:19 +0100, Alan Cox wrote:
> > > Don't forget to document how people are _supposed_ to use the v4l api
> > > from userspace, though.
> > 
> > Correct but those methods are not part of the V4L2 API and have not been
> > for some considerable time. 
> 
> It seems that message hadn't got through. Any suggestions as to how we
> could make sure it does in future?

Removing it appears to be the only effective message. No real news there.

Alan
