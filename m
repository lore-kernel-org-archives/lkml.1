Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXG3Wns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXG3Wns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbXG3Wnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:43:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbXG3Wng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:43:36 -0400
Date: Mon, 30 Jul 2007 15:43:32 -0700 (PDT)
Message-Id: <20070730.154332.72713181.davem@davemloft.net>
To: jeff@garzik.org
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com, gallatin@myri.com
Subject: Re: [PATCH 0/4][RFC] lro: Generic Large Receive Offload for TCP
 traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <46AE0F36.8030605@garzik.org>
References: <200707301724.33865.ossthema@de.ibm.com>
	<46AE0F36.8030605@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 30 Jul 2007 12:17:58 -0400

> David, thoughts on merging?  I'm not We could stick this into your tree 
> or mine.  Whether yours or mine, I would like to keep the driver and 
> net-core patches together in the same git tree.

No objections and I'll stick it into my net-2.6.24 tree once I cut
that, I'll have the NAPI stuff in there too so I'll keep these two
merge nightmares out of your hair :-)

