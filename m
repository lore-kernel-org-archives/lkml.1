Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbYBLXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbYBLXyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYBLXyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:54:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45969 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYBLXyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:54:06 -0500
Date: Tue, 12 Feb 2008 23:54:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212235401.GL27894@ZenIV.linux.org.uk>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.155107.251983955.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 03:51:07PM -0800, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Tue, 12 Feb 2008 11:31:48 -0500
> 
> > I understand the desire to want a nice and clean history, but the 
> > frequency here really has a negative impact on your downstreams.
> 
> Ok, fair enough.  Any alternative suggestions on how to remove turds
> without them being in the history?
> 
> > It also totally screws the commit statistics, wiping me and John and the 
> > committers we have preserved out, replacing everybody's committer with 
> > David Miller.
> 
> I am well aware of this downside, sorry.

Ahem...  Use of git-cherry-pick preserves commit information just fine.
