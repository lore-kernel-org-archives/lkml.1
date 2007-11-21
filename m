Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXKUNU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXKUNU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXKUNUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:20:49 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:36285 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXKUNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:20:48 -0500
Date: Wed, 21 Nov 2007 22:20:51 +0900 (JST)
Message-Id: <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20071121124532.GA17263@havoc.gtf.org>
References: <20071121124532.GA17263@havoc.gtf.org>
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

In article <20071121124532.GA17263@havoc.gtf.org> (at Wed, 21 Nov 2007 07:45:32 -0500), Jeff Garzik <jeff@garzik.org> says:

> 
> SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
> based on a reading of net/ipv4/udp.c.

Disagree. UDP checksum is mandatory in IPv6.

--yoshfuji
