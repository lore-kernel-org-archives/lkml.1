Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbXGFJeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbXGFJeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760471AbXGFJeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:34:18 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:42377 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbXGFJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:34:17 -0400
To: nigel@nigel.suspend2.net
CC: miklos@szeredi.hu, oliver@neukum.org, rjw@sisk.pl, nigel@suspend2.net,
       pavel@ucw.cz, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-reply-to: <200707061916.17590.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Fri, 6 Jul 2007 19:16:16 +1000)
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707060951.47555.oliver@neukum.org> <E1I6jot-0003U1-00@dorka.pomaz.szeredi.hu> <200707061916.17590.nigel@nigel.suspend2.net>
Message-Id: <E1I6kC8-0003af-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 11:33:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > VM induced deadlocks are real nasty.  I have thought about them a lot
> > already.  Suspend shouldn't introduce any big surprises.
> 
> Suspend isn't introducing the surprises. Fuse is. It creates the potential 
> deadlocks simply by existing (this isn't suspend or hibernate specific).

Yes.  And fuse is not going away any time soon.  Get over it ;)

Miklos
