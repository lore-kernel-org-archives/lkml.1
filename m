Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYALFMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYALFMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYALFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:12:20 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:34812 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYALFMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:12:19 -0500
Date: Sat, 12 Jan 2008 14:12:24 +0900 (JST)
Message-Id: <20080112.141224.06844600.yoshfuji@linux-ipv6.org>
To: davem@davemloft.net
Cc: andi@firstfloor.org, vaf@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20080111.174857.258424243.davem@davemloft.net>
References: <p73bq7smx1t.fsf@bingen.suse.de>
	<20080111.214120.129309556.yoshfuji@linux-ipv6.org>
	<20080111.174857.258424243.davem@davemloft.net>
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

In article <20080111.174857.258424243.davem@davemloft.net> (at Fri, 11 Jan 2008 17:48:57 -0800 (PST)), David Miller <davem@davemloft.net> says:

> From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
> Date: Fri, 11 Jan 2008 21:41:20 +0900 (JST)
> 
> > There is no positive consesus on this draft
> > at the intarea meeting in Vancouver, right?
> > 
> > We cannot / should not enable that space until we have reached
> > a consensus on it.
> 
> This is so incredibly incorrect.
> 
> There is consensus on making network stacks able to use this
> address space.  And that is all that the patch does.

No, we did never make consensus on it.

> The consensus is only missing on whether to make the address
> space public or private.
> 
> This is also clearly spelled out in the draft.
> 
> It is important to get as large of a head start on this as
> possible because of how long it takes to deploy something
> like this.

Okay, though I am afraid this space will not be used widely,
we should be ready for it.

I'll make some more comments on the patch itself from
another point view.

--yoshfuji

