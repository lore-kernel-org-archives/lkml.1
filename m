Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759427AbYLQKNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYLQKNv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYLQKNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:13:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754773AbYLQKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:13:39 -0500
Date: Wed, 17 Dec 2008 10:13:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Madru <bevicm@dslextreme.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
Message-ID: <20081217101307.4614145d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081216210251.138d3e98.akpm@linux-foundation.org>
References: <494318F5.4060007@gawab.com>
	<20081216210251.138d3e98.akpm@linux-foundation.org>
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

On Tue, 16 Dec 2008 21:02:51 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> (cc linux-ide).
> 
> This is a post-2.6.27 regression.  Panic!
> 
> On Fri, 12 Dec 2008 18:07:49 -0800 Justin Madru <bevicm@dslextreme.com> wrote:
> 
> > I've been testing .28 (currently -rc8) and I've noticed in the logs a 
> > massive amount of the following.
> > I can confirm that the messages doesn't appear when booting into a .27 
> > kernel.
> > 
> > ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> > ata2.00: ST_FIRST: !(DRQ|ERR|DF)

Which is the first 2.6.28-rc that this appears ?
