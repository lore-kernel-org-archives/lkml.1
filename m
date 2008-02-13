Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbYBMHaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbYBMHaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYBMHaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:30:25 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:46089 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbYBMHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:30:23 -0500
Date: Wed, 13 Feb 2008 18:31:02 +1100 (EST)
Message-Id: <20080213.183102.71846649.yoshfuji@linux-ipv6.org>
To: dada1@cosmosbay.com
Cc: johnpol@2ka.mipt.ru, ggriffin.kernel@gmail.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <47AAD203.4030706@cosmosbay.com>
References: <47a9fb13.01538c0a.3b80.ffff9328@mx.google.com>
	<20080207072415.GA13782@2ka.mipt.ru>
	<47AAD203.4030706@cosmosbay.com>
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

In article <47AAD203.4030706@cosmosbay.com> (at Thu, 07 Feb 2008 10:40:19 +0100), Eric Dumazet <dada1@cosmosbay.com> says:

> [NET] IPV4: lower stack usage in cookie_hash() function
> 
> 400 bytes allocated on stack might be a litle bit too much. Using a 
> per_cpu var is more friendly.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Applied to my inet6-2.6.26 tree.  Thanks.

--yoshfuji
