Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYIOWlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYIOWlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbYIOWlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:41:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43435
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbYIOWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:41:10 -0400
Date: Mon, 15 Sep 2008 15:41:05 -0700 (PDT)
Message-Id: <20080915.154105.161656793.davem@davemloft.net>
To: jeff@garzik.org
Cc: tsbogend@alpha.franken.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915223807.GC15421@havoc.gtf.org>
References: <20080915215307.GA10340@alpha.franken.de>
	<20080915.151125.93659986.davem@davemloft.net>
	<20080915223807.GC15421@havoc.gtf.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 15 Sep 2008 18:38:07 -0400

> He continues to take non-regression fixes and minor cosmetic commits
> from other trees.

I could complain about that, but he's pushed back hard enough
on me that I don't consider that very fruitful.

Feel free if you want.

> Late -rc does not mean "no bug fixes at all except regressions" if you
> look at the commits going into the kernel tree.

Actually, since you brought this up, he's allowing this largely in
obscure subsystems and/or code he happens to be personally working on
fixes for.
