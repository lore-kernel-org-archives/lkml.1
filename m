Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbYBKQHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbYBKQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYBKQHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:07:05 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:45090 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbYBKQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:07:03 -0500
Date: Tue, 12 Feb 2008 03:07:41 +1100 (EST)
Message-Id: <20080212.030741.132208013.yoshfuji@linux-ipv6.org>
To: ggriffin.kernel@gmail.com
Cc: dada1@cosmosbay.com, johnpol@2ka.mipt.ru, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <47abeba8.20588c0a.7013.ffff80d3@mx.google.com>
References: <47abe7b1.20588c0a.7013.75b7@mx.google.com>
	<47abeba8.20588c0a.7013.ffff80d3@mx.google.com>
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

In article <47abeba8.20588c0a.7013.ffff80d3@mx.google.com> (at Thu,  7 Feb 2008 21:49:26 -0800), Glenn Griffin <ggriffin.kernel@gmail.com> says:

> Updated to incorporate Eric's suggestion of using a per cpu buffer
> rather than allocating on the stack.  Just a two line change, but will
> resend in it's entirety.
> 
> Signed-off-by: Glenn Griffin <ggriffin.kernel@gmail.com>

Applied in my linux-2.6-dev tree.  Thanks.

--yoshfuji
