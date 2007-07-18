Return-Path: <linux-kernel-owner+w=401wt.eu-S1763418AbXGRWXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418AbXGRWXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXGRWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:23:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52850
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756082AbXGRWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:23:11 -0400
Date: Wed, 18 Jul 2007 15:23:10 -0700 (PDT)
Message-Id: <20070718.152310.124381122.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: hch@infradead.org, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [RFC 0/3] lro: Generic Large Receive Offload for TCP traffic
 (IPv6)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707181501.00163.ossthema@de.ibm.com>
References: <20070715091253.GA15790@infradead.org>
	<20070715.024015.126137834.davem@davemloft.net>
	<200707181501.00163.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Wed, 18 Jul 2007 15:00:59 +0200

> Hi,
> 
> I suggest we keep the interface open for IPv6 support by adding 
> an additional parameter but first just get IPv4 support only 
> into the kernel. IPv6 support can then incrementially be added.
> Would that be ok?

I guess so.
