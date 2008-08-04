Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYHDVcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYHDVcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYHDVbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:31:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51896
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbYHDVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:31:31 -0400
Date: Mon, 04 Aug 2008 14:31:28 -0700 (PDT)
Message-Id: <20080804.143128.47731600.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: greearb@candelatech.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] netdev: debugging option
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804093742.395d271e@extreme>
References: <20080719230424.190957a3@extreme>
	<20080720.000509.20260185.davem@davemloft.net>
	<20080804093742.395d271e@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 4 Aug 2008 09:37:42 -0700

> On Sun, 20 Jul 2008 00:05:09 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Stephen Hemminger <shemminger@vyatta.com>
> > Date: Sat, 19 Jul 2008 23:04:24 -0700
> > 
> > So we really need to add some kind of run time enable and also a
> > filter of some sort, even if it's just on device.
> 
> The sysctl in the patch is default off, so unless it is turned on,
> the log is quiet

I get a feeling you think I can just apply your patch now.

You can't respond to my gripes more than a week later and expect
the patch to still be in my inbox ready to apply.  I delete the
patch from my mailbox as soon as I have major issues with it.

If you think your reply means that the patch should be applied you
need to resubmit it.

Thanks.
