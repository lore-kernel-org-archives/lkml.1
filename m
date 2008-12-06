Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYLFA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYLFA3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYLFA3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:29:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291AbYLFA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:29:09 -0500
Date: Sat, 6 Dec 2008 00:29:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081206002912.7ed4defc@lxorguk.ukuu.org.uk>
In-Reply-To: <20081205211223.GA8075@ioremap.net>
References: <20081205180350.GA25236@ioremap.net>
	<20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	<ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
	<20081205192755.GA27712@ioremap.net>
	<20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	<20081205211223.GA8075@ioremap.net>
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

On Sat, 6 Dec 2008 00:12:23 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Fri, Dec 05, 2008 at 07:34:32PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > I can not run bisect, since reboot requires vnc and I'm far from fast
> > > channel. Build of the fresh tree with existing config takes almost
> > > one hour, but it should not be a major problem.
> > > 
> > > I can do bisection after the weekend, but can test some changes before
> > > machine froze with unsuccessful patch.
> > 
> > I really have no idea what you are seeing so short of a bisect I've
> > nothing to suggest.
> 
> But if things would be in userspace, then it should be fired long ago
> with .27 kernel, no?

I have no idea. A bisection will hopefully provide answers
