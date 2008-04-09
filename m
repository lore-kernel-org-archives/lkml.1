Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYDIR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYDIR3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDIR3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:29:05 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:32882 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYDIR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:29:04 -0400
Date: Thu, 10 Apr 2008 02:30:45 +0900 (JST)
Message-Id: <20080410.023045.16227424.yoshfuji@linux-ipv6.org>
To: lkml@rtr.ca
Cc: jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <47FCF9DD.6080007@rtr.ca>
References: <47FCC6B5.70804@rtr.ca>
	<47FCF2DD.30705@garzik.org>
	<47FCF9DD.6080007@rtr.ca>
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

In article <47FCF9DD.6080007@rtr.ca> (at Wed, 09 Apr 2008 13:16:13 -0400), Mark Lord <lkml@rtr.ca> says:

> I suppose a wireshark capture is next, once I dig out my ancient hub
> so we can sniff it from an independent box.

Or, you could do "git-bisect" if it is reproducible.

--yoshfuji
