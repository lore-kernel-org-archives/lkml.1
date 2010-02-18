Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0BRCBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:01:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44854
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102Ab0BRCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:01:07 -0500
Date: Wed, 17 Feb 2010 18:01:22 -0800 (PST)
Message-Id: <20100217.180122.195704088.davem@davemloft.net>
To: dave@thedillows.org
Cc: joe@perches.com, netdev@vger.kernel.org, zambrano@broadcom.com,
       mchan@broadcom.com, eilong@broadcom.com, romieu@fr.zoreil.com,
       shemminger@linux-foundation.org, mcarlson@broadcom.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] drivers/net: Use
 (pr|netdev|netif)_<level> macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266458447.5719.44.camel@obelisk.thedillows.org>
References: <cover.1266454575.git.joe@perches.com>
	<20100217.174615.133415843.davem@davemloft.net>
	<1266458447.5719.44.camel@obelisk.thedillows.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Dillow <dave@thedillows.org>
Date: Wed, 17 Feb 2010 21:00:47 -0500

> On Wed, 2010-02-17 at 17:46 -0800, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Wed, 17 Feb 2010 17:01:47 -0800
>> 
>> > Use the newly added netdev_<level> and netif_<level> logging macros
>> > in some of the drivers.
>> > 
>> > Adds some message logging consistency.
>> > 
>> > pci-skeleton had a checkpatch style cleaning as well.
>> 
>> The sis190.c and tg3.c changes didn't apply due to other
>> recent commits into the net-next-2.6 tree
>> 
>> I applied all of the others.
> 
> Have you pushed? I'd rather some of the typhoon ones not go in.

Why not?
