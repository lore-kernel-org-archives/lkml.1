Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbXIMIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbXIMIWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXIMIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:22:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbXIMIWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:22:09 -0400
Date: Thu, 13 Sep 2007 01:20:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Cc: davidel@xmailserver.org, vda.linux@googlemail.com, rdunlap@xenotime.net,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net
Subject: Re: timerfd redux
Message-Id: <20070913012044.c120d98f.akpm@linux-foundation.org>
In-Reply-To: <20070913081359.216550@gmx.net>
References: <20070825064114.107820@gmx.net>
	<20070904011800.762523a4.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
	<200709051312.21873.vda.linux@googlemail.com>
	<20070905153201.236690@gmx.net>
	<20070912193920.441cf901.akpm@linux-foundation.org>
	<20070913081359.216550@gmx.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 10:13:59 +0200 "Michael Kerrisk" <mtk-manpages@gmx.net> wrote:

> Andrew,
> 
> > > 3. possible solutions
> > 
> > I don't think we'll have this settled and coded in time for 2.6.23.  So I
> > think the prudent thing to do is to push this back to 2.6.24 and not offer
> > sys_timerfd() in 2.6.23.
> 
> Did you want a patch to remove the syscall number for now,
> or will you do that?
> 

Please send one over sometime.
