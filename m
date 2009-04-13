Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZDMXXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZDMXXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZDMXW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:22:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZDMXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:22:57 -0400
Date: Mon, 13 Apr 2009 16:22:48 -0700 (PDT)
Message-Id: <20090413.162248.60285999.davem@davemloft.net>
To: jesse.brandeburg@intel.com
Cc: amluto@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.WNT.2.00.0904091128270.6048@jbrandeb-desk1.amr.corp.intel.com>
References: <20090404.170539.148727646.davem@davemloft.net>
	<cb0375e10904042100o1a203512l593021ee66cb591d@mail.gmail.com>
	<alpine.WNT.2.00.0904091128270.6048@jbrandeb-desk1.amr.corp.intel.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Date: Thu, 9 Apr 2009 17:48:04 -0700 (Pacific Daylight Time)

> Dave, if we move the netif_carrier_off call to our dev->open like tg3 has, 
> do you think this is sufficient?

Yes.

> e1000e: indicate link down at load
> 
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> same kind of patch as e1000, let driver explicitly push link state
> once link comes up.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

I'll wait to get this via Jeff Kirsher.

Thanks.
