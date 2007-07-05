Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXGERua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXGERua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXGERuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:50:23 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45383 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbXGERuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:50:23 -0400
To: jeremy@goop.org
CC: miklos@szeredi.hu, rjw@sisk.pl, stern@rowland.harvard.edu,
       oliver@neukum.org, paulus@samba.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <468D17FA.8040201@goop.org> (message from Jeremy Fitzhardinge on
	Thu, 05 Jul 2007 09:10:34 -0700)
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org> <200707042336.58466.rjw@sisk.pl> <E1I6Mq2-0008WB-00@dorka.pomaz.szeredi.hu> <200707051439.37737.rjw@sisk.pl> <E1I6QcZ-0000ex-00@dorka.pomaz.szeredi.hu> <468D17FA.8040201@goop.org>
Message-Id: <E1I6VOM-0001LL-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 19:45:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Umm, and CODA which is _very_ similar to fuse was there long before
> > fuse or the freezer ;)
> >   
> 
> I did userfs around 1994-5.

Yes, fuse didn't in fact have very much original idea in it.  It was
just putting all the pieces together to make a stable and useful
userspace filesystem framework.

Miklos
