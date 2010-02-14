Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0BNTzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:55:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43714
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869Ab0BNTzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:55:15 -0500
Date: Sun, 14 Feb 2010 11:55:30 -0800 (PST)
Message-Id: <20100214.115530.216233071.davem@davemloft.net>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: switch to smp barriers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100213173911.GA5040@redhat.com>
References: <20100207090749.GA12968@redhat.com>
	<201002081849.39512.rusty@rustcorp.com.au>
	<20100213173911.GA5040@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sat, 13 Feb 2010 19:39:11 +0200

> Dave, I see it's marked "not applicable":
> http://patchwork.ozlabs.org/patch/44207/
> the patch applies to net-next as of
> b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73.
> Can this be queued up please?
> Should I resubmit with Rusty's ack?

Sorry about that, I must have thought Rusty would queue
it up.

I'll fix the state to under-review and process it in my
backlog.

Thanks.
