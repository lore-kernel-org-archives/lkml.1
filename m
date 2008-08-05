Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYHEI2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYHEI2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbYHEI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:28:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53872
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754593AbYHEI2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:28:14 -0400
Date: Tue, 05 Aug 2008 01:28:14 -0700 (PDT)
Message-Id: <20080805.012814.215633850.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080805021710.GA21731@tuxdriver.com>
References: <20080804193753.GA30345@tuxdriver.com>
	<20080804.150147.78586437.davem@davemloft.net>
	<20080805021710.GA21731@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 4 Aug 2008 22:17:10 -0400

> On Mon, Aug 04, 2008 at 03:01:47PM -0700, David Miller wrote:
> > I'm holding off on this pull until the list.h changes get so me lkml
> > ACKs.
> 
> Sure, np.  I created a "no-ath9k" branch in case you are feeling
> frisky -- it is the same except for omitting the list.h changes,
> the ath5k pci table change, and the new ath9k driver.
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git no-ath9k
> 
> Hth!

Thanks John.

Due to the powerpc build failures the list.h stuff causes, I'm going
to pull this so I can do a push to Linus tonight.

Although I highly encourare you to get that list.h stuff sorted out
because I'd really like to see ath9k get merged in as that's a useful
device to support for a lot of users.
