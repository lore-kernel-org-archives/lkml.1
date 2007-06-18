Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbXFRLHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbXFRLHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXFRLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:07:23 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:38704 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXFRLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:07:22 -0400
To: davem@davemloft.net
CC: tgraf@suug.ch, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20070618.040253.129088293.davem@davemloft.net> (message from
	David Miller on Mon, 18 Jun 2007 04:02:53 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <E1I0ElR-0007Kz-00@dorka.pomaz.szeredi.hu>
	<20070618.035144.64026005.davem@davemloft.net>
	<E1I0EtI-0007Ma-00@dorka.pomaz.szeredi.hu> <20070618.040253.129088293.davem@davemloft.net>
Message-Id: <E1I0F4B-0007PM-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 13:06:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm all for fixing this gc mess that we have now.  But please don't
> > expect me to be the one who's doing it.
> 
> Don't worry, I only expect you to make the situation worse :-)

That's real nice.  Looks like finding and fixing bugs in not
appreciated in the networking subsystem :-/

Miklos
