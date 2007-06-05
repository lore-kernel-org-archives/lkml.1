Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbXFEJlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbXFEJlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763234AbXFEJlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:41:10 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:40328 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763202AbXFEJlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:41:09 -0400
X-ME-UUID: 20070605094107238.3A1FE1C0008A@mwinf2707.orange.fr
Subject: Re: A kexec approach to hibernation
From: Xavier Bestel <xavier.bestel@free.fr>
To: Stefan Seyfried <seife@suse.de>
Cc: nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>,
       Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20070605093429.GB5229@suse.de>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
	 <20070604220910.GB2515@andrew.cmu.edu>
	 <1180996586.4356.65.camel@nigel.suspend2.net>
	 <1181031341.6863.164.camel@frg-rhel40-em64t-04>
	 <20070605093429.GB5229@suse.de>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 11:40:53 +0200
Message-Id: <1181036453.6863.172.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 11:34 +0200, Stefan Seyfried wrote:
> On Tue, Jun 05, 2007 at 10:15:41AM +0200, Xavier Bestel wrote:
> > FWIW, on my old laptop apm beats any kernel solution hands down in terms
> > of speed
> 
> This might be true on 64MB systems. It is surely not true on multi-Gigabyte-
> RAM setups. At least not if you actually use that memory for anything
> including filesystem cache.
> And you simply cannot buy a new machine today that still supports APM suspend
> to disk.

I don't contest that. I just say that technically, an "external kernel"
can suspend/hibernate a laptop very well.

	Xav


