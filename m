Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZKZXw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZKZXw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZKZXw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:52:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55169
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbZKZXw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:52:56 -0500
Date: Thu, 26 Nov 2009 15:53:14 -0800 (PST)
Message-Id: <20091126.155314.201869723.davem@davemloft.net>
To: kaber@trash.net
Cc: arnd@arndb.de, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       eric.dumazet@gmail.com, anna.fischer@hp.com,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       lk-netdev@lk-netdev.nosense.org, gerhard.stenzel@de.ibm.com,
       ebiederm@xmission.com, jens@linux.vnet.ibm.com, pmullaney@novell.com,
       shemminger@vyatta.com
Subject: Re: [PATCHv3 0/4] macvlan: add vepa and bridge mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B0EAC29.60601@trash.net>
References: <1259251631-11617-1-git-send-email-arnd@arndb.de>
	<4B0EAC29.60601@trash.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 26 Nov 2009 17:26:17 +0100

> Arnd Bergmann wrote:
>> Version 2 description:
>> The patch to iproute2 has not changed, so I'm not including
>> it this time. Patch 4/4 (the netlink interface) is basically
>> unchanged as well but included for completeness.
>> 
>> The other changes have moved forward a bit, to the point where
>> I find them a lot cleaner and am more confident in the code
>> being ready for inclusion. The implementation hardly resembles
>> Erics original patch now, so I've dropped his signed-off-by.
>> 
>> Please take a look and ack if you are happy so we can get it
>> into 2.6.33.
> 
> Looks good to me, nice work.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>
> 
> for the entire series.

All applied to net-next-2.6, thanks everyone!
