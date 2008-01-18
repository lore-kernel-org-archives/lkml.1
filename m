Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbYARCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbYARCP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbYARCPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:15:15 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:35506 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668AbYARCPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:15:13 -0500
Date: Fri, 18 Jan 2008 11:15:24 +0900 (JST)
Message-Id: <20080118.111524.102545566.yoshfuji@linux-ipv6.org>
To: jengelh@computergmbh.de
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@suse.de, vaf@cisco.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv4: Enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20080118.111319.30002290.yoshfuji@linux-ipv6.org>
References: <20080118.102635.01689255.yoshfuji@linux-ipv6.org>
	<Pine.LNX.4.64.0801180242270.14025@fbirervta.pbzchgretzou.qr>
	<20080118.111319.30002290.yoshfuji@linux-ipv6.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080118.111319.30002290.yoshfuji@linux-ipv6.org> (at Fri, 18 Jan 2008 11:13:19 +0900 (JST)), YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> says:

> Assuming IN_BADCLASS() is still there, we should not reuse the name
> of "ipv6_is_badclass" because the their meanings are different.

Again, ipv4_is_badclass()....
My hands almost automatically type "6" after "ipv"...

--yoshfuji
