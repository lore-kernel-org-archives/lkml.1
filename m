Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXC1JdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXC1JdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965524AbXC1JdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:33:01 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:35330 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965512AbXC1JdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:33:00 -0400
Date: Wed, 28 Mar 2007 18:33:46 +0900 (JST)
Message-Id: <20070328.183346.23403158.yoshfuji@linux-ipv6.org>
To: davem@davemloft.net
Cc: agoston@ripe.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: IPv6: Connection reset/timeout under heavy load
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070328.022624.59656162.davem@davemloft.net>
References: <460A2BDB.6080200@ripe.net>
	<20070328.182334.109744556.yoshfuji@linux-ipv6.org>
	<20070328.022624.59656162.davem@davemloft.net>
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

In article <20070328.022624.59656162.davem@davemloft.net> (at Wed, 28 Mar 2007 02:26:24 -0700 (PDT)), David Miller <davem@davemloft.net> says:

> > http://www.linux-ipv6.org/gitweb/gitweb.cgi?p=gitroot/yoshfuji/linux-2.6-fix.git;a=commit;h=33a79bba0cc2f197b46cc54182f94c31ff6ad334
> > 
> > I hope this patch will go in 2.6.16-stable...
> 
> Please forward this patch to Adrian Bunk (bunk@stusta.de),
> he will definitely add it to 2.6.16-stable for you.

I will do it again...

--yoshfuji
