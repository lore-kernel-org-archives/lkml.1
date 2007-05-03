Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXECKp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXECKp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030942AbXECKp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:45:27 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:59524 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbXECKp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:45:26 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 06:45:26 EDT
Date: Thu, 3 May 2007 12:34:55 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <d120d5000705011409o46b82708rf2cbfe3390141545@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0705031234010.8342@xplor.biophys.uni-duesseldorf.de>
References: <20070501203234.252205858@mail.of.borg>  <20070501203330.172479999@mail.of.borg>
  <20070501205740.GC21080@infradead.org> <d120d5000705011409o46b82708rf2cbfe3390141545@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +#define BUS_ATARI            0x1B
> >
> > Is this really a separate bus?  Should't we have a BUS_ONBOARD or so instead?
>
> BUS_HOST shoudl fit the bill.

OK, I'll use that one.

	Michael
