Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKTBOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKTBOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYKTBO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:14:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47956
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYKTBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:14:26 -0500
Date: Wed, 19 Nov 2008 17:14:26 -0800 (PST)
Message-Id: <20081119.171426.197284550.davem@davemloft.net>
To: yi.zou@intel.com
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: define feature flags for FCoE offloads
From: David Miller <davem@davemloft.net>
In-Reply-To: <1DB50624F8348F48840F2E2CF6040A9D2F383FB5@orsmsx508.amr.corp.intel.com>
References: <20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
	<20081119.154710.135220757.davem@davemloft.net>
	<1DB50624F8348F48840F2E2CF6040A9D2F383FB5@orsmsx508.amr.corp.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zou, Yi" <yi.zou@intel.com>
Date: Wed, 19 Nov 2008 16:02:03 -0800

> Thanks for reviewing the patch. I am hoping to make use of the
> existing gso logic as much as possible for fcoe segmentation as
> well, to hookup fcoe segmentation using ptype->gso_segment().

There is no way for anyone to evaluate this usage and determine
whether it makes sense or not until you post those patches.
