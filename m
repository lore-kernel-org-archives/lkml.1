Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZBNWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZBNWgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZBNWgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:36:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZBNWgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:36:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Bug #12661] commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
Date: Sat, 14 Feb 2009 23:35:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Chua <jeff.chua.linux@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.ueE.U20jJB@chimera> <20090209042307.GA3268@gondor.apana.org.au>
In-Reply-To: <20090209042307.GA3268@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142335.55904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Herbert Xu wrote:
> On Sun, Feb 08, 2009 at 08:21:46PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> 
> The patch in question has already been reverted.  So while we
> still need to track down the underlying problem with rlogin, it's
> no longer a kernel regression.

I've closed the bug, sorry for the slow response.

Thanks,
Rafael
