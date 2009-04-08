Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbZDHPN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbZDHPN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762280AbZDHPNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:13:46 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58128 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZDHPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:13:45 -0400
Date: Wed, 8 Apr 2009 17:12:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jack Stone <jwjstone@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
In-Reply-To: <20090408151032.GB20983@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0904081711090.9554@pc-004.diku.dk>
References: <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu>
 <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu>
 <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu>
 <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu>
 <49DCBBDF.4040603@fastmail.fm> <Pine.LNX.4.64.0904081705390.9554@pc-004.diku.dk>
 <20090408151032.GB20983@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Matthew Wilcox wrote:

> On Wed, Apr 08, 2009 at 05:06:57PM +0200, Julia Lawall wrote:
> > This can be helpful: http://lwn.net/Articles/284469/
> > 
> > It's a bit out of date, though, because git-blame seems to have 
> > disappeared as a command.
> 
> Are you just getting confused by the removal of the 'git-foo' form?
> 
> 'git blame' works, and I see:
> $ dpkg -S /usr/lib/git-core/git-blame 
> git-core: /usr/lib/git-core/git-blame

I just meant that the script uses git-blame, rather than git blame, so one 
has to edit it a bit to make it work (on gentoo at least).

But anyway the link sent by Jack looks even more useful.

julia
