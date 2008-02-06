Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbYBFCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbYBFCec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbYBFCeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:34:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758807AbYBFCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:34:22 -0500
Date: Tue, 5 Feb 2008 18:33:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: Pull request: TASK_KILLABLE
Message-Id: <20080205183351.200d6480.akpm@linux-foundation.org>
In-Reply-To: <20080206021942.GA21509@parisc-linux.org>
References: <20080129000447.GC31101@parisc-linux.org>
	<alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
	<20080131234504.GB25967@parisc-linux.org>
	<alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
	<1201830304.3087.2.camel@heimdal.trondhjem.org>
	<20080131180205.20e7dece.akpm@linux-foundation.org>
	<20080206021942.GA21509@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 19:19:42 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> > And going back through the mailing list all I can find is a series of five
> > patches in October - it's unclear where and when the other 17 were
> > reviewed, if they were.
> 
> A large number of these patches are just a resplit of the patches sent
> back in October -- you complained they weren't split up enough.  So I
> resplit them.  And sent them to you.  Asking if this was how you
> preferred it.  Which you didn't reply to.

Well, I apologise if that's the case, but...  I can find no record of the
later patch series.  Maybe an MTA ate them?


