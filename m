Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbYDKJJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYDKJJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbYDKJJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:09:36 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:33299 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102AbYDKJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:09:35 -0400
Date: Fri, 11 Apr 2008 18:11:19 +0900 (JST)
Message-Id: <20080411.181119.12087415.yoshfuji@linux-ipv6.org>
To: ramirose@gmail.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-2.6.26] [IPV6] Adjust IPV6 multicast routing module
 (ip6mr.c) to use mroute6 header declarations .
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <eb3ff54b0804100240x2cc3d21el3ce06b21ce7b5320@mail.gmail.com>
References: <eb3ff54b0804100240x2cc3d21el3ce06b21ce7b5320@mail.gmail.com>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <eb3ff54b0804100240x2cc3d21el3ce06b21ce7b5320@mail.gmail.com> (at Thu, 10 Apr 2008 12:40:10 +0300), "Rami Rosen" <ramirose@gmail.com> says:

> Hi,
> - This patch adjusts IPv6 multicast routing module, net/ipv6/ip6mr.c,
> to use mroute6 header definitions instead of mroute.
>  (MFC6_LINES instead of MFC_LINES, MAXMIFS instead of MAXVIFS, mifi_t
> instead of vifi_t.)
> 
> - In addition, inclusion of some headers was removed as it is not needed.
> 
> Regards,
> Rami Rosen

Applied, thanks.

--yoshfuji
