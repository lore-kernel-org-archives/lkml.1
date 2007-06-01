Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXFAEag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXFAEag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXFAEa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:30:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35638
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbXFAEa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:30:29 -0400
Date: Thu, 31 May 2007 21:30:42 -0700 (PDT)
Message-Id: <20070531.213042.76771817.davem@davemloft.net>
To: venkatesh.pallipadi@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070529180112.GC5411@linux-os.sc.intel.com>
References: <20070529180112.GC5411@linux-os.sc.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Tue, 29 May 2007 11:01:13 -0700

> 
> round_jiffies for net dev watchdog timer.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Patch applied, thanks.
