Return-Path: <linux-kernel-owner+w=401wt.eu-S940057AbXGaAAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940057AbXGaAAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbXGaAAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:00:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49866 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbXGaAAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:00:37 -0400
Message-ID: <46AE7B9E.7030505@garzik.org>
Date: Mon, 30 Jul 2007 20:00:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ossthema@de.ibm.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com, gallatin@myri.com
Subject: Re: [PATCH 0/4][RFC] lro: Generic Large Receive Offload for TCP traffic
References: <200707301724.33865.ossthema@de.ibm.com>	<46AE0F36.8030605@garzik.org> <20070730.154332.72713181.davem@davemloft.net>
In-Reply-To: <20070730.154332.72713181.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Mon, 30 Jul 2007 12:17:58 -0400
> 
>> David, thoughts on merging?  I'm not We could stick this into your tree 
>> or mine.  Whether yours or mine, I would like to keep the driver and 
>> net-core patches together in the same git tree.
> 
> No objections and I'll stick it into my net-2.6.24 tree once I cut
> that, I'll have the NAPI stuff in there too so I'll keep these two
> merge nightmares out of your hair :-)

Works for me.

Thanks,

	Jeff



