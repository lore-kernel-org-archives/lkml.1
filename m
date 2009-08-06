Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbZHFUZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbZHFUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZHFUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:25:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51331
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZHFUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:25:54 -0400
Date: Thu, 06 Aug 2009 13:26:04 -0700 (PDT)
Message-Id: <20090806.132604.241009415.davem@davemloft.net>
To: Steve.Glendinning@smsc.com
Cc: daniel@caiaq.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, netdev@vger.kernel.org,
       linux-sh@vger.kernel.org, Ian.Saturley@smsc.com
Subject: Re: [PATCH 5/5] net: smsc911x: switch to new dev_pm_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <OF06D1E485.71250FEA-ON8025760A.003F9572-8025760A.00415798@smsc.com>
References: <20090805.202922.241102337.davem@davemloft.net>
	<OF06D1E485.71250FEA-ON8025760A.003F9572-8025760A.00415798@smsc.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve.Glendinning@smsc.com
Date: Thu, 6 Aug 2009 12:53:45 +0100

> David Miller <davem@davemloft.net> wrote on 06/08/2009 04:29:22:
> 
>> From: Daniel Mack <daniel@caiaq.de>
>> Date: Wed,  5 Aug 2009 20:29:31 +0200
>> 
>> > Hibernation is unsupported for now, which meets the actual
>> > implementation in the driver. For free/thaw, the chip's D2 state 
> should
>> > be entered.
>> > 
>> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
>> 
>> Steve, if it looks good to you I can toss this into net-next-2.6
>> 
>> Just let me know.
> 
> Looks fine.  Compiles ok and doesn't actually change any PM 
> implementation.
> 
> Acked-by: <steve.glendinning@smsc.com>

Applied, thanks everyone.
