Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0BXHlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:41:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53797
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757Ab0BXHlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:41:18 -0500
Date: Tue, 23 Feb 2010 23:41:33 -0800 (PST)
Message-Id: <20100223.234133.85843944.davem@davemloft.net>
To: mst@redhat.com
Cc: gleb@redhat.com, rusty@rustcorp.com.au, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, markmc@redhat.com, herbert.xu@redhat.com,
       quintela@redhat.com, dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/3] vhost: fix get_user_pages_fast error handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100224073424.GC27806@redhat.com>
References: <20100224053737.GB27806@redhat.com>
	<20100223.230428.71578656.davem@davemloft.net>
	<20100224073424.GC27806@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 24 Feb 2010 09:34:25 +0200

> Implicitly, I guess. He said "if there's an issue Michael Tsirkin is the
> best person to resolve it", this was wrt merging his virtio&lguest tree.
> He didn't mention vhost, I wrote all of vhost though, there shouldn't be
> an issue with that.

That's good enough for me.

Feel free to setup a tree for me to pull from.
