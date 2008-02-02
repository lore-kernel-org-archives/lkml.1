Return-Path: <linux-kernel-owner+w=401wt.eu-S1765178AbYBBPke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765178AbYBBPke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbYBBPk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:40:27 -0500
Received: from 1wt.eu ([62.212.114.60]:1673 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbYBBPk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:40:27 -0500
Date: Sat, 2 Feb 2008 15:57:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.23.14
Message-ID: <20080202145737.GA2171@1wt.eu>
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu> <47A46BF8.6030306@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A46BF8.6030306@davidnewall.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 11:41:20PM +1030, David Newall wrote:
> Hi Willy,
> 
> Willy Tarreau wrote:
> > Based on the above conditions, I'd like you to tell Greg and I if you
> > consider it worth to merge this backport in 2.4 now. From my point of
> > view, your work looks OK but I want your feedback as a user (and not
> > as the backporter), then Greg's approval.
> 
> The data loss I experienced did go away with the back-port, but I think
> that was because of the bigger buffers, rather than any true fix. Other
> than the extra product ids, it won't really change anything. I'm hoping
> the additional work I've done since then will correct the underlying
> fault. (Wish I could get some feedback on it.) I'd be happy for you to
> wait for that.

OK I like your analysis, it makes sense. I'm not doing anything with
your patch then, and will wait for news from you.

Thanks,
Willy

