Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbXEXXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbXEXXQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXEXXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:16:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57526 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXEXXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:16:45 -0400
X-Sasl-enc: To3WaaVr2SUybwMfAL9+jzM8nzvpMKINlEbYf+GTVP2K 1180048603
Date: Thu, 24 May 2007 20:16:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070524231638.GC29678@khazad-dum.debian.net>
References: <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524223200.GE9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524223200.GE9604@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Pavel Machek wrote:
> My proposed solution is "fix pcmcia to load firmware before suspend
> even starts"

s/pcmcia/all drivers that load firmware/ if you are going to go that way.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
