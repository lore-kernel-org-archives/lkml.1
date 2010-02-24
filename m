Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0BXFlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 00:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0BXFlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 00:41:06 -0500
Date: Wed, 24 Feb 2010 07:37:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: gleb@redhat.com, rusty@rustcorp.com.au, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, markmc@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/3] vhost: fix get_user_pages_fast error handling
Message-ID: <20100224053737.GB27806@redhat.com>
References: <20100223173434.GB9834@redhat.com> <20100223173258.GA25338@redhat.com> <20100223173952.GC9834@redhat.com> <20100223.144235.08984181.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223.144235.08984181.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 02:42:35PM -0800, David Miller wrote:
> 
> Just for the record I'm generally not interested in vhost
> patches.
> 
> If it's a specific network one that will be merged via
> the networking tree, yes please CC: me.
> 
> But if it's a bunch of changes to vhost.c and other pieces
> of infrastructure, feel free to leave me out of it.  It just
> clutters my already overflowing inbox.
> 
> Thanks.

Dave, so while Rusty's on vacation, what's the best way to get vhost
infrastructure fixes in? Are you ok with getting pull requests and
merging them into net-next?  That should keep the clutter in your inbox
to the minimum.

Of course network changes would still go the usual way.

-- 
MST
