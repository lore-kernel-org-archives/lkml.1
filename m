Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXHVIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXHVIsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXHVIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:48:44 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3722 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXHVIso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:48:44 -0400
Date: Wed, 22 Aug 2007 10:48:27 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070822084827.GA6302@derision.cyrius.com>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <6101e8c40708211441g2ae20412u877082eb611f595e@mail.gmail.com> <Pine.LNX.4.64.0708220956540.20435@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708220956540.20435@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt <jengelh@computergmbh.de> [2007-08-22 09:57]:
> >I think it's bad idea, when removing support for gcc3.x, while some
> >people using debian 3.1 at now and under debian 3.1 the default
> >comiler is 3.3.5, when I good know or not!?
> They always lag behind.

Debian 4.0 has GCC 4.1 as the default compiler, and we use 4.1 to
compile our kernels on all architectures except of m68k.
-- 
Martin Michlmayr
http://www.cyrius.com/
