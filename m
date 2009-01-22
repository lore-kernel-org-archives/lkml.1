Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZAVVmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZAVVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZAVVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:42:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbZAVVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:42:22 -0500
Date: Thu, 22 Jan 2009 13:42:24 -0800 (PST)
Message-Id: <20090122.134224.224850288.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-01-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090122194320.GD3646@tuxdriver.com>
References: <20090122194320.GD3646@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 22 Jan 2009 14:43:21 -0500

> Here is this week's round of fixes intended for 2.6.29.  Most of them
> are small and obvious.  There are a couple of bigger ones for p54,
> one that corrects some frame corruption on monitor interfaces and
> another that corrects a potential use-after-free bug.  There is also
> an orinoco patch that looks big because it is moving some code around
> to avoid a locking issue.  All of them have cooked in wireless-testing
> and have had extensive testing.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Pulled, thanks a lot John.
