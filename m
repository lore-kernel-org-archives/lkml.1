Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbXDNRMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbXDNRMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXDNRMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:12:05 -0400
Received: from stinky.trash.net ([213.144.137.162]:63982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbXDNRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:12:04 -0400
Message-ID: <46210B0E.2040209@trash.net>
Date: Sat, 14 Apr 2007 19:10:38 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulus@samba.org, poemann@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
References: <461DC70B.4000500@trash.net>	<20070413.161635.26523891.davem@davemloft.net>	<17953.1560.855914.274514@cargo.ozlabs.ibm.com> <20070414.100441.15000708.davem@davemloft.net>
In-Reply-To: <20070414.100441.15000708.davem@davemloft.net>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Paul Mackerras <paulus@samba.org>
> Date: Sun, 15 Apr 2007 02:49:28 +1000
> 
> 
>>I didn't see the patch (the message that this is a reply to is the
>>first one that I have seen in this thread), so I can't comment on it.
> 
> 
> Here is Patrick McHardy's patch:
> 
> [..]


I haven't heard back from Bartek yet. In case the patch is correct,
ppp_synctty seems to need the same fix.

