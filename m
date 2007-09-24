Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbXIXQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbXIXQ4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXIXQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:56:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544AbXIXQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:56:12 -0400
Date: Mon, 24 Sep 2007 09:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac: Driver model & phylib update
Message-Id: <20070924095559.c81f7061.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0709241529570.22491@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
	<20070921124409.7f3d122b.akpm@linux-foundation.org>
	<Pine.LNX.4.64N.0709241529570.22491@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 15:41:54 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> On Fri, 21 Sep 2007, Andrew Morton wrote:
> 
> > >  A driver model and phylib update.
> > 
> > akpm:/usr/src/25> diffstat patches/git-net.patch | tail -n 1
> >  1013 files changed, 187667 insertions(+), 23587 deletions(-)
> > 
> > Sorry, but raising networking patches against Linus's crufty
> > old mainline tree just isn't viable at present.
> 
>  Well, this is against Jeff's netdev-2.6 tree which hopefully is not as 
> crufty as Linus's old mainline; if it is not possible to queue this change 
> for 2.6.25 or suchlike, then I will try to resubmit later.

Most of Jeff's netdev tree got dumped into Dave's net-2.6.24 tree.  That's
the one you want to be raising patches against for the next few weeks.

