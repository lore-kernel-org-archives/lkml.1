Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZAEOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZAEOWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZAEOWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:22:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:49537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZAEOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:22:40 -0500
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to
 request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>, davem@redhat.com,
       jgarzik@redhat.com, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mchan@broadcom.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <3f9a31f40901050612v700d2542r1e3e400bf0fe3d33@mail.gmail.com>
References: <1230626497.24796.26.camel@jaswinder.satnam>
	 <49620AFE.6040409@hartkopp.net>
	 <3f9a31f40901050612v700d2542r1e3e400bf0fe3d33@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 14:22:31 +0000
Message-Id: <1231165351.8286.279.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 19:42 +0530, Jaswinder Singh Rajput wrote:
> On Mon, Jan 5, 2009 at 6:58 PM, Oliver Hartkopp <oliver@hartkopp.net> wrote:
> > 077f849de42e58172e25ccb24df4c1a13e82420c ("firmware: convert tg3 driver to
> > request_firmware()")
> >
> > and i discovered that
> >
> > 1. I needed to compile the tg3 driver as *module* now as it was not able to
> > read the firmware when built-in.
> >
> 
> Please compile it as build in.
> 
> David Woodhouse: Do you have any plans to support firmware by using modules.

Que?

-- 
dwmw2

