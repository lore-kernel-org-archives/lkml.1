Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYGBVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYGBVdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYGBVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:33:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34772
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754449AbYGBVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:33:26 -0400
Date: Wed, 02 Jul 2008 14:33:27 -0700 (PDT)
Message-Id: <20080702.143327.183259418.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-07-02
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080702202653.GA10719@tuxdriver.com>
References: <20080630215651.GA666@tuxdriver.com>
	<20080702193710.GA4682@tuxdriver.com>
	<20080702202653.GA10719@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 2 Jul 2008 16:26:53 -0400

> NOTE: This is the same as the request posted on 2008-06-30 except for
> dropping two iwlwifi patches that were sent for 2.6.26 instead.
> 
> Dave,
> 
> Here is another slew of updates for 2.6.27.  The bulk of this batch is
> for iwlwifi, with some mac80211 and other bits thrown-in.
> 
> Let me know if there are problems!

Thanks John.  I think I'll pull this in after Linus pulls
net-2.6, I pull in your net-2.6 pull, and then do a merge
of net-2.6 into net-next-2.6

Thanks!
