Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbXIFJvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbXIFJvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXIFJvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:51:25 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:47582
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbXIFJvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:51:24 -0400
Date: Thu, 06 Sep 2007 02:50:46 -0700 (PDT)
Message-Id: <20070906.025046.74721747.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       takamiya@po.ntts.co.jp
Subject: Re: net-26.24 broken with XFRM off
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070906101326.34a81abb.dada1@cosmosbay.com>
References: <46DFAB7F.7060406@chelsio.com>
	<20070906101326.34a81abb.dada1@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 6 Sep 2007 10:13:26 +0200

> I believe this problem is known.
> 
> Please check http://marc.info/?l=linux-netdev&m=118881627028135&w=2 

I'll toss that fix into the tree, thanks.
