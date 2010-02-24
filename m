Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0BXHEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:04:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47187
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab0BXHEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:04:12 -0500
Date: Tue, 23 Feb 2010 23:04:28 -0800 (PST)
Message-Id: <20100223.230428.71578656.davem@davemloft.net>
To: mst@redhat.com
Cc: gleb@redhat.com, rusty@rustcorp.com.au, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, markmc@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/3] vhost: fix get_user_pages_fast error handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100224053737.GB27806@redhat.com>
References: <20100223173952.GC9834@redhat.com>
	<20100223.144235.08984181.davem@davemloft.net>
	<20100224053737.GB27806@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 24 Feb 2010 07:37:37 +0200

> Dave, so while Rusty's on vacation, what's the best way to get vhost
> infrastructure fixes in? Are you ok with getting pull requests and
> merging them into net-next?  That should keep the clutter in your inbox
> to the minimum.
> 
> Of course network changes would still go the usual way.

Well, who is providing oversight of vhost work while he's
gone?  Has he, implicitly or explicitly, appointed a maintainer
while he's away?
