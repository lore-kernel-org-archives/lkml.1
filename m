Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbXCTXfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbXCTXfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934086AbXCTXe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:34:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934085AbXCTXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:34:58 -0400
Date: Tue, 20 Mar 2007 16:34:56 -0700 (PDT)
Message-Id: <20070320.163456.41638776.davem@davemloft.net>
To: mst@dev.mellanox.co.il
Cc: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org, rolandd@cisco.com
Subject: Re: dst_ifdown breaks infiniband?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070320160217.GC31495@mellanox.co.il>
References: <20070319151336.GA24225@mellanox.co.il>
	<20070319232043.GA23359@ms2.inr.ac.ru>
	<20070320160217.GC31495@mellanox.co.il>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Date: Tue, 20 Mar 2007 18:02:17 +0200

> David, Alexey, what do you think about this patch? Is it right?
> Could this patch be considered for 2.6.21?
> 
> Acked-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

I plan to apply it and merge.
