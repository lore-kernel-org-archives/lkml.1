Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbYASPa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbYASPa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbYASPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:30:11 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:37155 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612AbYASPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:30:08 -0500
Date: Sun, 20 Jan 2008 00:30:19 +0900 (JST)
Message-Id: <20080120.003019.119068925.yoshfuji@linux-ipv6.org>
To: jengelh@computergmbh.de, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ak@suse.de,
       vaf@cisco.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPv4: Enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0801191443410.27831@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801180242270.14025@fbirervta.pbzchgretzou.qr>
	<20080118.111319.30002290.yoshfuji@linux-ipv6.org>
	<Pine.LNX.4.64.0801191443410.27831@fbirervta.pbzchgretzou.qr>
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

In article <Pine.LNX.4.64.0801191443410.27831@fbirervta.pbzchgretzou.qr> (at Sat, 19 Jan 2008 14:44:13 +0100 (CET)), Jan Engelhardt <jengelh@computergmbh.de> says:

> From 84bccef295aa9754ee662191e32ba1d64edce2ba Mon Sep 17 00:00:00 2001
> From: Jan Engelhardt <jengelh@computergmbh.de>
> Date: Fri, 18 Jan 2008 02:10:44 +0100
> Subject: [PATCH] IPv4: enable use of 240/4 address space
> 
> This short patch modifies the IPv4 networking to enable use of the
> 240.0.0.0/4 (aka "class-E") address space as propsed in the internet
> draft draft-fuller-240space-00.txt.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

--yoshfuji
