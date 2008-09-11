Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYIKWiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYIKWiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 18:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYIKWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 18:37:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53531
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYIKWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:37:50 -0400
Date: Thu, 11 Sep 2008 15:37:43 -0700 (PDT)
Message-Id: <20080911.153743.113096478.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-09-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080911201308.GJ3423@tuxdriver.com>
References: <20080911201308.GJ3423@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Sep 2008 16:13:09 -0400

> Here is one fix for 2.6.27.  It is a backport of a patch that is already
> in net-next-2.6.  Since it is for a new driver (ath9k) and since it
> fixes a reported bug (http://bugzilla.kernel.org/show_bug.cgi?id=11394)
> I think it should be OK to pass it to Linus for the current cycle.

Pulled and pushed back out to net-2.6, thanks John.
