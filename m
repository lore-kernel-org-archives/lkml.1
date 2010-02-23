Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0BWWmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:42:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39905
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab0BWWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:42:18 -0500
Date: Tue, 23 Feb 2010 14:42:35 -0800 (PST)
Message-Id: <20100223.144235.08984181.davem@davemloft.net>
To: gleb@redhat.com
Cc: mst@redhat.com, rusty@rustcorp.com.au, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, markmc@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/3] vhost: fix get_user_pages_fast error handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100223173952.GC9834@redhat.com>
References: <20100223173434.GB9834@redhat.com>
	<20100223173258.GA25338@redhat.com>
	<20100223173952.GC9834@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just for the record I'm generally not interested in vhost
patches.

If it's a specific network one that will be merged via
the networking tree, yes please CC: me.

But if it's a bunch of changes to vhost.c and other pieces
of infrastructure, feel free to leave me out of it.  It just
clutters my already overflowing inbox.

Thanks.
