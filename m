Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXFEIXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXFEIXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXFEIXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:23:32 -0400
Received: from smtp24.orange.fr ([193.252.22.25]:48047 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbXFEIXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:23:30 -0400
X-ME-UUID: 20070605081552499.79F641C00093@mwinf2458.orange.fr
Subject: Re: A kexec approach to hibernation
From: Xavier Bestel <xavier.bestel@free.fr>
To: nigel@nigel.suspend2.net
Cc: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>,
       Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <1180996586.4356.65.camel@nigel.suspend2.net>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
	 <20070604220910.GB2515@andrew.cmu.edu>
	 <1180996586.4356.65.camel@nigel.suspend2.net>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 10:15:41 +0200
Message-Id: <1181031341.6863.164.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 08:36 +1000, Nigel Cunningham wrote:
> I spent some time, last I think, seriously considering this approach.
> The more I thought about the details, the more I realised that it wasn't
> a viable approach. As I said before, it does indeed sound like a dream
> at first, but once you get into the details, it becomes more and more of
> a nightmare.

>From very far, it looks like apm suspend (i.e. an "external" system
taking control of the computer for hibernation and resuming).
FWIW, on my old laptop apm beats any kernel solution hands down in terms
of speed and robustness. Not that this means anything for kexec-suspend.

	Xav


