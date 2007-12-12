Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXLLWGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXLLWGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXLLWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:06:13 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:43561 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXLLWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:06:12 -0500
Date: Thu, 13 Dec 2007 07:06:41 +0900 (JST)
Message-Id: <20071213.070641.20411400.yoshfuji@linux-ipv6.org>
To: cfriesen@nortel.com
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: "ip neigh show" not showing arp cache entries?
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <47605934.2060604@nortel.com>
References: <4760279E.1080203@nortel.com>
	<47602DD0.8070402@cosmosbay.com>
	<47605934.2060604@nortel.com>
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

In article <47605934.2060604@nortel.com> (at Wed, 12 Dec 2007 15:57:08 -0600), "Chris Friesen" <cfriesen@nortel.com> says:

> > You may try other versions of this command
> > 
> > http://devresources.linux-foundation.org/dev/iproute2/download/
> 
> They appear to be numbered by kernel version, and the above version is 
> the most recent one for 2.6.14.  Will more recent ones (for newer 
> kernels) work with my kernel?

It should work; if it doesn't, please make a report.  Thanks.

--yoshfuji
