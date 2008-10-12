Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYJLVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYJLVrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 17:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYJLVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 17:47:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57496
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbYJLVr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 17:47:28 -0400
Date: Sun, 12 Oct 2008 14:47:04 -0700 (PDT)
Message-Id: <20081012.144704.39192150.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Please pull - generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <m33aj15xhr.fsf@maximus.localdomain>
References: <m33aj15xhr.fsf@maximus.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 12 Oct 2008 23:12:16 +0200

> David,
> 
> The following changes since commit
> f3073ac76755abd63b1d4c3d145f4c15b65b5355 (i.e., your netdev-2.6):
> Guennadi Liakhovetski (1): smc911x: Fix external PHY detection
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git for-david

You've missed the networking merge window, as I stated the other
day I'm not taking any more networking changes.

You should have merged this in earlier.

--------------------
Subject: preparing net-next-2.6 for merge...
From: David Miller <davem@davemloft.net>
To: netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Date: Fri, 10 Oct 2008 12:29:37 -0700 (PDT)
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)


I'm doing some quick merge, build, and boot tests on the tree as it
stands right now then I'll send a pull request to Linus.

I'm sure there are some things people still wanted to get into the
tree, but let's try to follow the rules this time.  Only bug fixes
and corrections at this point forward.

Look at it this way, I have tons of stuff I wasn't able to finish up
in time either, so both the rule and the pain and being applied fairly
:-)

Anyways, just FYI...
