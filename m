Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYIOWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYIOWLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYIOWLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:11:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46047
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756072AbYIOWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:11:31 -0400
Date: Mon, 15 Sep 2008 15:11:25 -0700 (PDT)
Message-Id: <20080915.151125.93659986.davem@davemloft.net>
To: tsbogend@alpha.franken.de
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915215307.GA10340@alpha.franken.de>
References: <20080915204543.GD3994@havoc.gtf.org>
	<20080915.141442.139271313.davem@davemloft.net>
	<20080915215307.GA10340@alpha.franken.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Date: Mon, 15 Sep 2008 23:53:08 +0200

> On Mon, Sep 15, 2008 at 02:14:42PM -0700, David Miller wrote:
> > Most of those changes were complete and utter CRAP.
> 
> thank you, but the fix I've sent (de2104x) isn't crap. The bug breaks the 
> current debian-installer for Cobalt Qube1, when it tries to get an
> IP address via dhcp. 

And why is this bug that has been there for YEARS is appropriate
to fix outside of the merge window?

> In my eyes it's a clean and good fix,

There are a lot of clean and good fixes, but that is not the
criteria for outside-of-the merge-window submissions right now.

Linus has made this clear.
