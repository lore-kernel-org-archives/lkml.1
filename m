Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZFSWtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZFSWtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZFSWtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:49:19 -0400
Received: from khc.piap.pl ([195.187.100.11]:45040 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZFSWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:49:17 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, Jouni Malinen <j@w1.fi>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>, Greg KH <greg@kroah.com>,
       "corbet\@lwn.net" <corbet@lwn.net>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan\@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata\@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge window
References: <20090615214735.GE23972@bombadil.infradead.org>
	<20090615223206.GA4966@kroah.com> <20090616004122.GC5492@tesla>
	<20090616021011.GF23972@bombadil.infradead.org>
	<20090616032034.GA17932@kroah.com> <20090616042113.GA5680@tesla>
	<20090616093401.GA11602@jm.kir.nu> <20090616181705.GB31506@tesla>
	<20090619150015.GC1389@ucw.cz>
	<43e72e890906191010v4b2e79a5x2c7b722b8209933c@mail.gmail.com>
	<20090619221909.GC2229@elf.ucw.cz>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 20 Jun 2009 00:49:16 +0200
In-Reply-To: <20090619221909.GC2229@elf.ucw.cz> (Pavel Machek's message of "Sat\, 20 Jun 2009 00\:19\:09 +0200")
Message-ID: <m3fxdv4z6b.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Non-intrusive bugfixes _are_ welcome after -rc1.

I'm under impression that the merge window is for new features, and past
rc1 only fixes are accepted. It may be different past maybe rc6, and
obviously the fixes must be sane enough (even in merge window).

Do they have to fix a bug? I don't know, I guess they can also fix "an
issue" :-)
-- 
Krzysztof Halasa
