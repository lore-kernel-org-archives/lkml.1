Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYKSXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYKSXrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYKSXrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:47:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41174
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYKSXrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:47:10 -0500
Date: Wed, 19 Nov 2008 15:47:10 -0800 (PST)
Message-Id: <20081119.154710.135220757.davem@davemloft.net>
To: yi.zou@intel.com
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: define feature flags for FCoE offloads
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
References: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
	<20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zou <yi.zou@intel.com>
Date: Mon, 17 Nov 2008 10:30:51 -0800

> From: Chris Leech <christopher.leech@intel.com>
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
> Signed-off-by: Yi Zou <yi.zou@intel.com>

Why would FibreChannel over Ethernet need IPV4/IPV6 segmentation
offloading?
