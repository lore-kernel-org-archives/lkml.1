Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXFRIVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXFRIVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXFRIVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:21:11 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:53633 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbXFRIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:21:09 -0400
To: davem@davemloft.net
CC: viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20070618.005711.21897961.davem@davemloft.net> (message from
	David Miller on Mon, 18 Jun 2007 00:57:11 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <20070607.184731.10907840.davem@davemloft.net>
	<E1HxgeN-0006Io-00@dorka.pomaz.szeredi.hu>
	<E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu> <20070618.005711.21897961.davem@davemloft.net>
Message-Id: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 10:20:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Miklos Szeredi <miklos@szeredi.hu>
> Date: Mon, 18 Jun 2007 09:49:32 +0200
> 
> > Ping Dave,
> > 
> > Since there doesn't seem to be any new ideas forthcoming, can we
> > please decide on either one of my two sumbitted patches?
> 
> You just need to be patient, we can't just put a bad patch
> in because a better one has not been suggested yet :-)

And is anyone working on a better patch?

Those patches aren't "bad" in the correctness sense.  So IMO any one
of them is better, than having that bug in there.

Miklos
