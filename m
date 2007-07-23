Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXGWQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXGWQkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763462AbXGWQk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:40:27 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42896 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762872AbXGWQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:40:26 -0400
To: viro@ftp.linux.org.uk
CC: pavel@ucw.cz, linux-kernel@vger.kernel.org, ericvh@gmail.com,
       rminnich@lanl.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net
In-reply-to: <20070723161550.GJ21668@ftp.linux.org.uk> (message from Al Viro
	on Mon, 23 Jul 2007 17:15:50 +0100)
Subject: Re: Plan 9 Resource Sharing Support - what is it?
References: <20070723075434.GA9162@elf.ucw.cz> <20070723161550.GJ21668@ftp.linux.org.uk>
Message-Id: <E1ID0wh-0005WX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jul 2007 18:39:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   Plan 9 Resource Sharing Support (9P2000) (Experimental) (NET_9P)
> > [N/m/y/?] (NEW) ?
> > 
> > If you say Y here, you will get experimental support for
> > Plan 9 resource sharing via the 9P2000 protocol.
> > 
> > See <http://v9fs.sf.net> for more information.
> > 
> > If unsure, say N.
> > 
> > What is "plan 9 resource sharing"? Some kind of mosix-like process
> > migration? Could you explain it in two lines in Kconfig?
> 
> 9P is the protocol used by Plan 9 remote/userland filesystem servers.
> FUSE is its considerably more bloated and less sane analog.

Heh, I think a similar analogy could be said about Plan9 vs. Linux.
With about the same result in user bases ;)

Miklos
