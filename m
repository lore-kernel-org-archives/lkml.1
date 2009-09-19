Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZISKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZISKdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 06:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZISKdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 06:33:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:51651 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZISKdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 06:33:45 -0400
Date: Sat, 19 Sep 2009 12:33:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 7/7] w35und: Remove some write-only struct members
In-Reply-To: <20090919101901.GA518@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0909191232580.17028@wotan.suse.de>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi> <20090812081550.GG23832@elf.ucw.cz> <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
 <20090919101901.GA518@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009, Pavel Machek wrote:

> > >> There's no point in keeping around struct members that are only written
> > >> to but never read.
> > >>
> > >> Cc: Pavel Machek <pavel@ucw.cz>
> > >> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > >
> > > ACK, but... Note I no longer have access to the hardware. It is
> > > probably collecting dust in czech suse labs somewhere.
> > 
> > OK, do you still want to be CC'd on the patches? I much appreciate the review!
> > 
> > Btw, is there someone at czech suse labs interested in testing w35und?
> > I don't have the hardware either which leaves us with just one
> > tester... :-)
> 
> Can we get some help? Kohjinsha seems to be one of the very few
> machines with that hw...

Jiri (the other one :) ) currently has this machine afaik, adding him to 
CC.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
