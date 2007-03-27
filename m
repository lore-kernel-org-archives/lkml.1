Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXC0Kpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXC0Kpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXC0Kpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:45:51 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:35243 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbXC0Kpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:45:50 -0400
Date: Tue, 27 Mar 2007 19:46:36 +0900 (JST)
Message-Id: <20070327.194636.63219035.yoshfuji@linux-ipv6.org>
To: agoston@ripe.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPv6: Connection reset/timeout under heavy load
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <4608E7CA.3090001@ripe.net>
References: <4608E7CA.3090001@ripe.net>
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

Hello.

(CC: netdev added.)

In article <4608E7CA.3090001@ripe.net> (at Tue, 27 Mar 2007 11:45:46 +0200), Agoston Horvath <agoston@ripe.net> says:

> I'm using kernel 2.6.16.29, libc is 2.3.2.ds1-22sarge5. However, same result was achieved using kernel version 2.6.13 on the same box.
> 
> I'm out of further ideas. If anyone can give me some pointers about what could be wrong, please, don't spare me.

Would you test with latest kernel, if possible, please?

--yoshfuji
