Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYAPUft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYAPUft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYAPUfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:35:41 -0500
Received: from 1wt.eu ([62.212.114.60]:1349 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYAPUfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:35:40 -0500
Date: Wed, 16 Jan 2008 21:14:00 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080116201400.GD8953@1wt.eu>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 16, 2008 at 05:04:17PM +0100, Jiri Kosina wrote:
> On Wed, 16 Jan 2008, Adrian Bunk wrote:
> 
> > RSS feed of the git tree:
> > http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss
> > Changes since 2.6.16.57:
> > Adrian Bunk (3):
> >       ipv4/arp.c:arp_process(): remove bogus #ifdef mess
> >       Linux 2.6.16.58-rc1
> >       Linux 2.6.16.58
> 
> Hi Adrian,
> 
> I don't seem to see v2.6.16.58 tag in your git repository -- the HEAD 
> (a8d648b74) is tagged v2.6.16.58-rc1. Is that intended?

Not replying for Adrian, but it happened several times to me too.
What sometimes happens when we push Git updates from home is that
we don't push all the refs. Sometimes I forget to update the tags,
sometimes the master, etc...

Just looked at the git repo itself, it looks like it has not changed
since 2008/01/08 :-/

Adrian, maybe your git-push did not succeed ?

Regards,
Willy

