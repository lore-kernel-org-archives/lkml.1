Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYFCWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYFCWDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbYFCWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:03:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48405
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbYFCWDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:03:14 -0400
Date: Tue, 03 Jun 2008 15:03:13 -0700 (PDT)
Message-Id: <20080603.150313.27318034.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       mokuno@sm.sony.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: wext: Emit event stream entries correctly when
 compat.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4845BF11.7070604@lwfinger.net>
References: <20080603.132856.202640855.davem@davemloft.net>
	<4845BF11.7070604@lwfinger.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 03 Jun 2008 17:00:49 -0500

> What tree should be used for this patch? On wireless-testing that 
> git-describe lists as v2.6.26-rc4-8782-gd9a8bd7, hunk 5 for mlme.c fails.

I said in the 0/12 posting that the patches are based upon
net-next-2.6
