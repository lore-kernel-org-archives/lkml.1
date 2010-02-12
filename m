Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0BLU2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:28:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52508
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab0BLU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:28:10 -0500
Date: Fri, 12 Feb 2010 12:28:23 -0800 (PST)
Message-Id: <20100212.122823.149317307.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, rusty@rustcorp.com.au,
       mst@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] virtio_net: remove send queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265674482.4484.10.camel@localhost.localdomain>
References: <1265674482.4484.10.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Mon, 08 Feb 2010 16:14:42 -0800

> Now we have a virtio detach API (in commit
> f9bfbebf34eab707b065116cdc9699d25ba4252a), we don't need to track xmit
> skbs in the virio_net driver, which improves transmission performance.
> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied to net-next-2.6, thanks everyone.
