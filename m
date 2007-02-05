Return-Path: <linux-kernel-owner+w=401wt.eu-S964916AbXBEWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916AbXBEWJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964905AbXBEWJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:09:36 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54240 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854AbXBEWJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:34 -0500
Date: Mon, 5 Feb 2007 14:12:33 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, Chris Wright <chrisw@sous-sol.org>,
       torvalds@osdl.org, akpm@osdl.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/50] -stable review
Message-ID: <20070205221233.GU10475@sequoia.sous-sol.org>
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205214332.GB18230@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Sun, Feb 04, 2007 at 01:24:18PM -0500, Michael Krufky wrote:
> > At which point was 2.6.18.y dropped?  I thought we were always going to keep
> > the last two stable kernels up-to-date.

Not quite.  It's more of a "some overlap," so that as soon as 2.6.x
comes out we don't instantly drop 2.6.(x-1).y stream.  But we don't keep
it going, typically more 1 or 2 2.6.(x-1).y releases once 2.6.x is out.

> > Have I been wasting my time fwd'ing
> > 2.6.18.y patches?

I had actually queued them up, but we only had 1 or 2 other patches,
and they weren't significant enough to warrant flushing that queue.

thanks,
-chris
