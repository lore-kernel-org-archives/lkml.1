Return-Path: <linux-kernel-owner+w=401wt.eu-S936230AbYEUDxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936230AbYEUDxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935421AbYEUDmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:42:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41462
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935352AbYEUDmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:42:03 -0400
Date: Tue, 20 May 2008 20:41:57 -0700 (PDT)
Message-Id: <20080520.204157.93481519.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-05-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080521025716.GA11085@tuxdriver.com>
References: <20080521025716.GA11085@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 20 May 2008 22:57:16 -0400

> Another round of fixes intended for 2.6.26...one of these ("ath5k: Fix
> loop variable initializations") is already queued in net-next-2.6, but
> it fixes the following bugzilla:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=10605
> 
> Also included is "mac80211: fix NULL pointer dereference in
> ieee80211_compatible_rates", which fixes another bugzilla:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=10755

Pulled and pushed back out to net-2.6, thanks John!
