Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYHMB6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYHMB6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYHMB6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:58:42 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753510AbYHMB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:58:41 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: divy@chelsio.com (Divy Le Ray)
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Cc: davem@davemloft.net, rdreier@cisco.com, rick.jones2@hp.com,
       jgarzik@pobox.com, swise@opengridcomputing.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <200808121521.10101.divy@chelsio.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev,apana.lists.os.linux.scsi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KT5cW-0007si-00@gondolin.me.apana.org.au>
Date: Wed, 13 Aug 2008 11:57:52 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray <divy@chelsio.com> wrote:
>
> Herbert requested some benchmark numbers, I consequently obliged.

Have you posted a hardware-accelerated iSCSI vs. LRO comparison?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
