Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZEEE1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZEEE1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZEEE1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:27:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43090
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbZEEE1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:27:12 -0400
Date: Mon, 04 May 2009 21:27:07 -0700 (PDT)
Message-Id: <20090504.212707.169008432.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: add missing include to virtio_net.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <200905051354.22713.rusty@rustcorp.com.au>
References: <20090428154654.19053.92829.stgit@localhost.localdomain>
	<200905051354.22713.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 5 May 2009 13:54:22 +0930

> On Wed, 29 Apr 2009 01:16:54 am Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> virtio_net.h uses the macro ETH_ALEN which is defined in linux/if_ether.h.
>> Discovered when hacking on virtio-over-pci patches.
> 
> Thanks, I've applied this.

Rusty, all of this is in net-2.6 already.

Thanks for paying attention! :-)
