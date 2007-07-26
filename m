Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXGZSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXGZSgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934442AbXGZSgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:36:20 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49329 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429AbXGZSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:36:18 -0400
Date: Thu, 26 Jul 2007 13:37:10 -0500 (CDT)
Message-Id: <20070726.133710.12677267.yoshfuji@linux-ipv6.org>
To: davem@davemloft.net
Cc: djohnson+linux-kernel@sw.starentnetworks.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       sakkiped@starentnetworks.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193
 addresses
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070725.171203.102545287.davem@davemloft.net>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
	<20070725.171203.102545287.davem@davemloft.net>
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
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070725.171203.102545287.davem@davemloft.net> (at Wed, 25 Jul 2007 17:12:03 -0700 (PDT)), David Miller <davem@davemloft.net> says:

> Contrarily, there may be ipv6_addr_type() call sites that really
> do want to reject rfc4193 addresses.

I do not think we have such users.

--yoshfuji
