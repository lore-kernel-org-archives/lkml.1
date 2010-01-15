Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0AOIYR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206Ab0AOIYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:24:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43488
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab0AOIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:24:16 -0500
Date: Fri, 15 Jan 2010 00:24:24 -0800 (PST)
Message-Id: <20100115.002424.100105244.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B5023A6.5070100@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.1001131633490.26518@ask.diku.dk>
	<20100115010315.GA29093@hexapodia.org>
	<4B5023A6.5070100@s5r6.in-berlin.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 09:13:26 +0100

> Tell me again in what way the script is of any importance or of any help
> in the permanent SCM changelog after commit.

I find them extremely useful when going through old as well
as new changes.

> I agree with you that it is very good to have the script in the patch
> posting, but I disagree about the changelog.

Thanks for making me go comb the mailing list archives instead of
having the information readily available when looking at a change in
the git history.

I frankly think all of your objections to this kind of thing as well
as putting patchwork URLs into the MAINTAINERS file quite rediculious.

Putting something 100 times (or more) into the kernel tree
documentation or commit messages is a good thing, because people are
going to find the information they need faster.

And likewise here, I want to see what the hell found the bug by
reading the changelog message.

I want more information in changelog messages, not less.  A commit
log message is never too long and never gives too much information
about the change, ever...
