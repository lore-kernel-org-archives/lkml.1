Return-Path: <linux-kernel-owner+w=401wt.eu-S1763977AbXGJSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763977AbXGJSsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXGJSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:48:41 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:54248 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbXGJSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:48:39 -0400
To: davem@davemloft.net
CC: akpm@linux-foundation.org, miklos@szeredi.hu, netdev@vger.kernel.org,
       ebiederm@xmission.com, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20070710.105520.30182869.davem@davemloft.net> (message from
	David Miller on Tue, 10 Jul 2007 10:55:20 -0700 (PDT))
Subject: Re: [PATCH re-resend] fix race in AF_UNIX garbage collector
References: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
	<20070710030443.f2deaab6.akpm@linux-foundation.org> <20070710.105520.30182869.davem@davemloft.net>
Message-Id: <E1I8KkV-0006Hq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Jul 2007 20:47:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, 10 Jul 2007 11:50:30 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > Can you please add this to -mm.  Sometimes that has wonderful effect
> > > on the willingness of people to look at a patch.
> > 
> > sure ;)
> 
> Andrew please don't, it's in my "to review" pile.

Yeah, and I can guess, where it is sitting in that pile ;)

Dave, if you are busy, just say so.  But if you don't reply anything,
I'm bound to think the patch is being ignored.

I apologize for being annoying.  Just let's get over this bloody bug ;)

Thanks,
Miklos
