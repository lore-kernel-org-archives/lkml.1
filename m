Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYDXCqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYDXCqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDXCqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:46:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39120
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbYDXCqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:46:13 -0400
Date: Wed, 23 Apr 2008 19:46:15 -0700 (PDT)
Message-Id: <20080423.194615.12446386.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-04-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080424015543.GA16453@tuxdriver.com>
References: <20080424015543.GA16453@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 23 Apr 2008 21:55:43 -0400

> Here is a round of fixes for 2.6.26.  The only ones that aren't strictly
> fixes are a MAINTAINERS update for mac80211 and a change in the element
> ID values used for 802.11s to avoid conflicts with approved portions of
> the standard -- those seem worthy of fix status to me. :-)
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.

I'll push this out to net-2.6 after I do some build validation and
fix some other issues in my tree.

Thanks!
