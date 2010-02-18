Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0BRAfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:35:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60280
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab0BRAfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:35:16 -0500
Date: Wed, 17 Feb 2010 16:35:32 -0800 (PST)
Message-Id: <20100217.163532.215667805.davem@davemloft.net>
To: mst@redhat.com
Cc: herbert@gondor.apana.org.au, paul.moore@hp.com, David.Woodhouse@intel.com,
       sri@us.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tun: linux socket filter support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100214110051.GA30182@redhat.com>
References: <20100214110051.GA30182@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 14 Feb 2010 13:00:51 +0200

> tun module already support RX filtering, however,
> this is limited to filtering by mac address.
> For virtio host, we also need filtering by vlan.
> 
> Rather than adding this directly, it seems cleaner
> to add generic socket filter support.

Both applied to net-next-2.6, thanks!
