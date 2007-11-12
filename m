Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXKLXlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXKLXlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXKLXkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:40:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57362
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbXKLXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:40:49 -0500
Date: Mon, 12 Nov 2007 15:40:46 -0800 (PST)
Message-Id: <20071112.154046.117031917.davem@davemloft.net>
To: w@1wt.eu
Cc: cfriesen@nortel.com, kaber@trash.net, auke-jan.h.kok@intel.com,
       joonwpark81@gmail.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071112233257.GA15524@1wt.eu>
References: <20071112231516.GA15227@1wt.eu>
	<20071112.151923.77768525.davem@davemloft.net>
	<20071112233257.GA15524@1wt.eu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Tue, 13 Nov 2007 00:32:57 +0100

> At least, being able to disable the feature at module load time
> would be acceptable. Many people who often need to sniff on decent
> machines would always keep it disabled.

I'm willing to accept the feature, in whatever form, as long
as the performance issue is dealt with properly.
