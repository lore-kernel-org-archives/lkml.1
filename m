Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbXBVMjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbXBVMjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbXBVMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:39:09 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:57096 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbXBVMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:39:07 -0500
Date: Thu, 22 Feb 2007 21:39:15 +0900 (JST)
Message-Id: <20070222.213915.89824941.yoshfuji@linux-ipv6.org>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 2/7] cxgb3 - private ioctl cleanup
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <45DD8DDA.8060303@chelsio.com>
References: <20070222115925.10001.61276.stgit@localhost.localdomain>
	<20070222.210618.134161490.yoshfuji@linux-ipv6.org>
	<45DD8DDA.8060303@chelsio.com>
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

In article <45DD8DDA.8060303@chelsio.com> (at Thu, 22 Feb 2007 04:34:34 -0800), Divy Le Ray <divy@chelsio.com> says:


> > 1. Please do do change the values.
> > 2. Explain why you are going to kill these ioctls.
> >   
> Jeff and Arjan have required that most of these ioctls go.
> Please read:
> http://marc.theaimsgroup.com/?l=linux-netdev&m=117029584904193&w=2

Even if you remove them, PLEASE DO NOT CHANGE THE VALUES,
unless you have very, very good reason.

--yoshfuji
