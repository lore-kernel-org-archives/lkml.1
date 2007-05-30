Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXE3W3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXE3W3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbXE3W32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:29:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44075
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759555AbXE3W30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:29:26 -0400
Date: Wed, 30 May 2007 15:29:39 -0700 (PDT)
Message-Id: <20070530.152939.21591222.davem@davemloft.net>
To: mpm@selenic.com
Cc: kaber@trash.net, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070530221039.GJ11166@waste.org>
References: <465DC598.5060407@trash.net>
	<20070530.125551.41636333.davem@davemloft.net>
	<20070530221039.GJ11166@waste.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Wed, 30 May 2007 17:10:39 -0500

> Are you agreeing that "it seems wasteful to add per-packet overhead"?
> This patch is not doing that.

Yes, and I know that :-)
