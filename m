Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZKQHq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZKQHq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZKQHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:46:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60330
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbZKQHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:46:27 -0500
Date: Mon, 16 Nov 2009 23:46:43 -0800 (PST)
Message-Id: <20091116.234643.137631670.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-11-16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091116162655.GD14410@tuxdriver.com>
References: <20091116162655.GD14410@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 16 Nov 2009 11:26:55 -0500

> The biggest is a revert of the patch that added cfg80211 support
> to ipw2200.  It was ill conceived and inadvertantly caused problems
> for ipw2100.  There are fixes available now, but they are just as
> big as the revert -- I'll restage them for 2.6.33.  There is little
> activity in ipw2200, so it the revert should be set.  Plus, I've
> tested the revert locally.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Pulled, thanks a lot.
