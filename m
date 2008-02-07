Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbYBGPOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbYBGPOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbYBGPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:13:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46810 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932105AbYBGPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:13:48 -0500
Date: Thu, 7 Feb 2008 15:07:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Friesen <cfriesen@nortel.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207150720.2ac6d2c4@core>
In-Reply-To: <47AB1D91.6090609@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<20080203124849.0226560f@weinigel.se>
	<84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
	<47A5F418.6030104@weinigel.se>
	<20080203231530.GB15692@kroah.com>
	<courier.47A8EDDC.0000785F@hawking.rebel.net.au>
	<47A8F27F.3060504@nortel.com>
	<20080206210452.GB7198@cs181133002.pp.htv.fi>
	<47AB06F9.30201@davidnewall.com>
	<20080207141557.5fcf3b2d@core>
	<47AB1D91.6090609@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> previous statements which seemed to say, "you've spoken to numerous

Please don't use "seemed to say" and then quote words I've never said.
That's misleading, rude and also awful language style. I've not said
anything is definite because as I said before there is no caselaw.

We know the GPL is enforcable (Germany and US)
We have good reason to believe works can be derivative across all sorts
of boundaries (non computing caselaw, cases that never went to court - eg
objective C)

Nobody has yet sued anyone to my knowledge over the module case because
quite frankly the list of blatant binary only shipping of GPL code
without licence, sources or offers people will keep us busy for quite
some time yet.

I actually don't expect to see that case tested - it isn't in anyones
interest to test it right now. ATI are being good boys at last, the other
big vendors that did binary modules are moving away and in several cases
I know have been told 'no more binary modules' and Nvidia are a company
without a processor in a world where graphics is going to be on CPU soon.
Lets say I don't own any Nvidia shares.

Alan
