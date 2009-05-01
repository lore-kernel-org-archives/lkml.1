Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbZEAWei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbZEAWei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZEAWeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:34:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60181
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757532AbZEAWeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:34:23 -0400
Date: Fri, 01 May 2009 15:34:17 -0700 (PDT)
Message-Id: <20090501.153417.135761259.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] virtio: add missing include to virtio_net.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090428154654.19053.92829.stgit@localhost.localdomain>
References: <20090428154654.19053.92829.stgit@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 28 Apr 2009 09:46:54 -0600

> virtio_net.h uses the macro ETH_ALEN which is defined in linux/if_ether.h.
> Discovered when hacking on virtio-over-pci patches.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.
