Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914Ab0A2KOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0A2KOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889Ab0A2KOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:14:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0A2KOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:14:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/3] net: maintain namespace isolation between vlan and real device
Date: Fri, 29 Jan 2010 11:12:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: shemminger@linux-foundation.org, kaber@trash.net, mst@redhat.com,
       herbert@gondor.apana.org.au, ogerlitz@voltaire.com,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <201001271104.20607.arnd@arndb.de> <201001271105.15733.arnd@arndb.de> <20100128.213344.226776729.davem@davemloft.net>
In-Reply-To: <20100128.213344.226776729.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001291112.05278.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Lo85M3RhkoR21n/kQimF6V8fO3KRa6EDnNx3
 0/HYBWclExtRR4bfs7ht2oVLScrORPtlpaladNW0EIbW6ZzUTs
 G4NrkqgkRSuiamEYMSgvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 January 2010, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Wed, 27 Jan 2010 11:05:15 +0100
> 
> > + * skb_dev_set -- assign a buffer to a new device
> 
> My english is terrible, but I think this should be
> "assign a new device to a buffer".

Right, that seems clearer.

> If you agree, please fix this up when you resubmit patches #1 and #2
> along with the fix you already plan to make to patch #3.

Ok, will do.

Thanks,

	Arnd
