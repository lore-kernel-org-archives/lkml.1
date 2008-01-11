Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbYAKMla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbYAKMla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYAKMlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:41:20 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:34803 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbYAKMlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:41:19 -0500
Date: Fri, 11 Jan 2008 21:41:20 +0900 (JST)
Message-Id: <20080111.214120.129309556.yoshfuji@linux-ipv6.org>
To: andi@firstfloor.org
Cc: vaf@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <p73bq7smx1t.fsf@bingen.suse.de>
References: <20080108011057.GA21168@cisco.com>
	<p73bq7smx1t.fsf@bingen.suse.de>
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

In article <p73bq7smx1t.fsf@bingen.suse.de> (at Fri, 11 Jan 2008 12:17:02 +0100), Andi Kleen <andi@firstfloor.org> says:

> Vince Fuller <vaf@cisco.com> writes:
> 
> > from Vince Fuller <vaf@vaf.net>
> >
> > This set of diffs modify the 2.6.20 kernel to enable use of the 240/4
> > (aka "class-E") address space as consistent with the Internet Draft
> > draft-fuller-240space-00.txt.
> 
> Wouldn't it be wise to at least wait for it becoming an RFC first? 

I do think so, too.

There is no positive consesus on this draft
at the intarea meeting in Vancouver, right?

We cannot / should not enable that space until we have reached
a consensus on it.

--yoshfuji
