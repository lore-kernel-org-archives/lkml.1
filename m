Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbYHHCmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbYHHCmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHHClz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:41:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48030
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYHHCly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:41:54 -0400
Date: Thu, 07 Aug 2008 19:41:55 -0700 (PDT)
Message-Id: <20080807.194155.136073681.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6#ath9k 2008-08-07
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080807143834.GB27762@tuxdriver.com>
References: <20080807143834.GB27762@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 7 Aug 2008 10:38:34 -0400

> I know we all want to see ath9k merged ASAP.  Since I'll be unavailable
> this weekend, I have created a branch that includes Luis's revamped
> list.h patches, the original ath9k patches, Adrian's ath9k gcc bug
> work-around patch, and another cleanup series from Sujith on top.
> 
> Hopefully no further problems will reveal themselves with the list.h
> stuff.  Please pull at your leisure, or if a problem arises I'll work to
> resolve it on Monday.

Looks good, pulled and pushed out to kernel.org, thanks!
