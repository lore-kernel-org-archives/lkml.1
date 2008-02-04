Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYBDCZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYBDCZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYBDCYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:24:48 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:43645 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbYBDCYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:24:47 -0500
Date: Mon, 04 Feb 2008 13:25:18 +1100 (EST)
Message-Id: <20080204.132518.63717287.yoshfuji@linux-ipv6.org>
To: lizf@cn.fujitsu.com
Cc: davem@davemloft.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] IPV4: fix compile error building without CONFIG_FS_PROC
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <47A660A1.5080504@cn.fujitsu.com>
References: <47A55846.20709@cn.fujitsu.com>
	<47A660A1.5080504@cn.fujitsu.com>
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

In article <47A660A1.5080504@cn.fujitsu.com> (at Mon, 04 Feb 2008 08:47:29 +0800), Li Zefan <lizf@cn.fujitsu.com> says:

> compile error building without CONFIG_FS_PROC.
:
> The exit method should have no return values...

Have you really tested this with CONFIG_FS_PROC?

--yoshfuji
