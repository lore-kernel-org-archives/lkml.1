Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXKABKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXKABKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 21:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXKABKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 21:10:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42254
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbXKABKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 21:10:08 -0400
Date: Wed, 31 Oct 2007 18:10:07 -0700 (PDT)
Message-Id: <20071031.181007.262649935.davem@davemloft.net>
To: greearb@candelatech.com
Cc: shemminger@linux-foundation.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4729269A.6090606@candelatech.com>
References: <18216.52455.698606.497464@zeus.sw.starentnetworks.com>
	<20071031123359.3954befc@freepuppy.rosehill>
	<4729269A.6090606@candelatech.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>
Date: Wed, 31 Oct 2007 18:06:34 -0700

> DaveM did the HW Accel for VLANs if I remember correctly...perhaps he 
> has some input?

Not really, I'm busy and also not motivated to work on this, someone
else will need to.
