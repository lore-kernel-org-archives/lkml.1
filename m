Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYBHXkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYBHXkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYBHXkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:40:31 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35460 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYBHXk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:40:29 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <47ACA204.7030702@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com>
	 <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
	 <courier.47A8497B.0000472E@hawking.rebel.net.au>
	 <1202240590.15090.119.camel@violet>  <47AB0A76.3000404@davidnewall.com>
	 <1202411113.15090.263.camel@violet>  <47ABD317.5060805@davidnewall.com>
	 <1202462101.15090.300.camel@violet>  <47ACA204.7030702@davidnewall.com>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 00:41:12 +0100
Message-Id: <1202514072.15090.359.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > Anyway you are still under the impression that a Linux kernel module can
> > be original work in the end. We keep telling you that could be a wrong
> > assumption which is based on the view of many of the kernel developers
> > and of most of the lawyers that looked at this specific topic.
> >   
> Yes, I am of that view. I accept that I could be wrong, but that also
> means that I could be right. We agree, so far. The important point is
> that I could be right. What will be done when somebody brings forth such
> an work? Will the restriction in EXPORT_SYMBOL_GPL be removed, or will
> the driver be unfairly restricted from using those other modules? You
> did agree I could be right, so positing such a driver, what happens? (I
> predict nothing; the driver is unfairly restricted.)

whatever you feel you get away with, but hey I am not a lawyer and my
reading is that any kernel module is derivative work and thus has to be
placed under GPL. Feel free to disagree with me. If you think you can
convince me, than you are under the wrong impression. Since even if (and
this is a big if) I am wrong, my action won't lead to a copyright
violation. Yours however would if you are wrong. So pick your battle.

> USB drivers must NOT be restricted to GPL-licence only; that would
> damage Linux.

Not writing and publishing GPL drivers damages Linux. Nothing else.

> > And while you are talking to a lawyer. Ask him/her if it is okay to
> > create a binary only application that uses a GPL library. Tell him/her
> > that it is original work.
> 
> Where does this come from? It's right out of left field. Since I've
> never suggested such a thing, could you please do me the courtesy of
> retracting the suggestion that I have?

Lets phrase this in better words as Valdis pointed out: You can't
distribute an application (binary or source form) under anything else
than GPL if it uses a GPL library. It makes no difference if you
distribute the GPL library with it or not.

But hey (again), feel free to disagree with me here.

Regards

Marcel


