Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZBCXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZBCXR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZBCXRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:17:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53282
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbZBCXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:17:20 -0500
Date: Tue, 03 Feb 2009 15:17:17 -0800 (PST)
Message-Id: <20090203.151717.234471646.davem@davemloft.net>
To: dcn@sgi.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: link XPNET's net_device_ops to its net_device
 structure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090203162451.GA32228@sgi.com>
References: <20090203162451.GA32228@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dean Nelson <dcn@sgi.com>
Date: Tue, 3 Feb 2009 10:24:51 -0600

> A recent patch by Stephen Hemminger to convert XPNET to use net_device_ops and
> internal net_device_stats failed to link the net_device_ops structure to the
> net_device structure. See commit e8ac9c55f28482f5b2f497a8e7eb90985db237c2.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>

Applied.

Please CC: netdev@vger.kernel.org for networking patches in the future
so that they get properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

Thank you.
