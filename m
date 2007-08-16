Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbXHPGs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbXHPGs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXHPGsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:48:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXHPGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:48:39 -0400
Date: Thu, 16 Aug 2007 09:48:26 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus branch
Message-ID: <20070816064826.GB19432@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adamyws2lry.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamyws2lry.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Dotan Barak (3):
>       IB: Include <linux/list.h> from <rdma/ib_mad.h>
>       IB: Include <linux/list.h> and <linux/rwsem.h> from <rdma/ib_verbs.h>

Hmm, if these things are appropriate for 2.6.23, maybe my patch
adding linux/mutex.h to ehca_classes.h can go in too?

-- 
MST
