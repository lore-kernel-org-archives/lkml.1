Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZJ0IVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZJ0IVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZJ0IVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:21:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZJ0IVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:21:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Date: Tue, 27 Oct 2009 09:23:07 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Boyan <btanastasov@yahoo.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       " =?iso-8859-1?q?Fr=E9d=E9ric_L=2E_W=2E?= Meunier" 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <4AE621CB.6000700@yahoo.co.uk> <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910270923.07912.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Linus Torvalds wrote:
> 
> On Tue, 27 Oct 2009, Boyan wrote:
> > 
> > I think it is fixed in 2.6.31.5. I can't reproduce the problem with it.
> 
> It was fixed by mainline commit c8e33141911bf8fe87dc6c92793b9a59b2be0130 
> ("tty: Make flush_to_ldisc() locking more robust"), which got back-ported 
> to 2.6.31.5 as commit 86d23a057.

Thanks, closing.

Rafael
