Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYIOWIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYIOWIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYIOWHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:07:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54211
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYIOWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:07:52 -0400
Date: Mon, 15 Sep 2008 15:07:46 -0700 (PDT)
Message-Id: <20080915.150746.24873255.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915212459.GE3994@havoc.gtf.org>
References: <20080915.132716.267218808.davem@davemloft.net>
	<20080915.141159.181213705.davem@davemloft.net>
	<20080915212459.GE3994@havoc.gtf.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 15 Sep 2008 17:24:59 -0400

> So, my takeaway from this is...
> 
> 1) Creating a bugzilla entry magically makes a bug fix acceptable?

It adds more credence to the bug.  Because it's usually reported
by a user.

> 2) We no longer want "this kills the driver" fixes?

I don't take that away from what I said.

Why is it so important to fix something "RIGHT NOW" that
has existed forever?  Where were these fixes during the
merge window?

> I disagree with that logic, and I seriously doubt Linus wants to turn
> away serious fixes to serious problems.

He wants the time outside of the merge window to work on fixing
regressions and exploitable problems.  This is so that the process
actually ends at some point.

> You just rejected patches that (a) fixed dead ethernet [de2104x],

And it's getting submitted now, because?!?

 (b) fixed an
> oops [WAN], and

It's WAN, it's been there forever, who cares and why now?

> (c) fixed memory corruption [ehea].

Again, it's been there for quite some time, why is it "now"
all of sudden now important to integrate this fix?
