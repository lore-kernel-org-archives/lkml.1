Return-Path: <linux-kernel-owner+w=401wt.eu-S1765620AbYCGASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765620AbYCGASZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYCGASJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:18:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34239
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754604AbYCGASH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:18:07 -0500
Date: Thu, 06 Mar 2008 16:18:07 -0800 (PST)
Message-Id: <20080306.161807.185339076.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jonas@southpole.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, greg@kroah.com
Subject: Re: [PATCH] net: use DECLARE_PCI_DEVICE_TABLE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080306154150.0ba906fa.akpm@linux-foundation.org>
References: <1204800947-21569-1-git-send-email-jonas@southpole.se>
	<1204800947-21569-2-git-send-email-jonas@southpole.se>
	<20080306154150.0ba906fa.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Mar 2008 15:41:50 -0800

> So I wouldn't go adding code which uses this thing until it has a correct
> name, and until we've decided that we actually want to live with it.

I personally think it's noise.
