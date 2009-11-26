Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbZKZQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbZKZQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZKZQ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:26:18 -0500
Received: from stinky.trash.net ([213.144.137.162]:58058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760688AbZKZQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:26:17 -0500
Message-ID: <4B0EAC29.60601@trash.net>
Date: Thu, 26 Nov 2009 17:26:17 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCHv3 0/4] macvlan: add vepa and bridge mode
References: <1259251631-11617-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1259251631-11617-1-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Version 2 description:
> The patch to iproute2 has not changed, so I'm not including
> it this time. Patch 4/4 (the netlink interface) is basically
> unchanged as well but included for completeness.
> 
> The other changes have moved forward a bit, to the point where
> I find them a lot cleaner and am more confident in the code
> being ready for inclusion. The implementation hardly resembles
> Erics original patch now, so I've dropped his signed-off-by.
> 
> Please take a look and ack if you are happy so we can get it
> into 2.6.33.

Looks good to me, nice work.

Acked-by: Patrick McHardy <kaber@trash.net>

for the entire series.
