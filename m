Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXHVIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXHVIo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXHVIow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:44:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59386 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbXHVIov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:44:51 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus branch
Date: Wed, 22 Aug 2007 10:44:48 +0200
User-Agent: KMail/1.8.2
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
References: <adamyws2lry.fsf@cisco.com> <20070816064826.GB19432@mellanox.co.il> <adaps1n1mgh.fsf@cisco.com>
In-Reply-To: <adaps1n1mgh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221044.48933.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Thursday 16 August 2007 18:19, Roland Dreier wrote:
>  > Hmm, if these things are appropriate for 2.6.23, maybe my patch
>  > adding linux/mutex.h to ehca_classes.h can go in too?
> 
> Actually I queued Dotan's patches quite a while ago, although Linus
> seems to be ignoring my pull requests.
> 
> I don't see any urgency in adding more similar patches to 2.6.23,
> since AFAIK 2.6.23 builds fine, right?

Yes, there is no build issue with 2.6.23. 
We have realized on rhel4.5 that linux/mutex.h needs to be included
explicitly.
Thus, I'm fine with your decision.
> 
> Also I would prefer to get ehca patches from the ehca people at IBM,
> or at least an ack from them.

Acked-by: Stefan Roscher <stefan.roscher@de.ibm.com>

regards Stefan

