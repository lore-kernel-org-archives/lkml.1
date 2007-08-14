Return-Path: <linux-kernel-owner+w=401wt.eu-S934388AbXHNSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388AbXHNSza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbXHNSzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:55:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4827 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764558AbXHNSzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:55:02 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@gmail.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>
	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
	 <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost>
	 <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 11:54:48 -0700
Message-Id: <1187117688.32555.149.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 11:40 -0700, Linus Torvalds wrote:
> Anyway - the script can certainly be tweaked, the point is 
> really just that the git tree _already_ contains the relevant 
> information).

I believe it's not specific enough.
Things like email lists would never show up.

