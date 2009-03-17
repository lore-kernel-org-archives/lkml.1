Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbZCQVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbZCQVkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZCQVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:40:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34070
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbZCQVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:40:03 -0400
Date: Tue, 17 Mar 2009 14:39:49 -0700 (PDT)
Message-Id: <20090317.143949.250643299.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2009-03-16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090316231423.GA3633@tuxdriver.com>
References: <20090316231423.GA3633@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 16 Mar 2009 19:14:24 -0400

> Here is a group of patches intended for 2.6.29.  The one from me is
> minor, but it cuts-down on log SPAM for ipw2100, ipw2200, and hostap
> users.  The two from Jouni fix some panics he observed himself.
> 
> The first one from Luis fixes bug 12110 at bugzilla.kernel.org.  I know
> he has worked on it for a long time and I've had several desperate users
> asking for it, so it must be good. :-)  Unfortunately, it causes some
> nasty merge errors with what is in net-next-2.6 and wireless-next-2.6.
> I created a merge-test branch in wireless-next-2.6, and the merge commit
> log goes into more detail about resolving the issue.  In short, you
> probably want to diff drivers/net/ath9k against the merge-test branch...
> 
> Please let me know if there are problems!

Pulled, thanks John.

Wish me luck with the net-next-2.6 merge :-)
