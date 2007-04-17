Return-Path: <linux-kernel-owner+w=401wt.eu-S1161368AbXDQWNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161368AbXDQWNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXDQWNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:13:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58557 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161368AbXDQWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:13:49 -0400
Date: Tue, 17 Apr 2007 23:17:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070417231706.0abe4b23@the-village.bc.nu>
In-Reply-To: <f03fgh$2o1$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org>
	<657751.18080.qm@web36614.mail.mud.yahoo.com>
	<20070417211653.GB11944@one.firstfloor.org>
	<1176846088.5946.62.camel@localhost.localdomain>
	<f03fgh$2o1$1@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a different reaction.  Given that the ease of use vs
> completeness issues are not completely understood, I would think
> it would make more sense to include both in the kernel.  Wasn't that
> the whole point of the LSM interface, to let competing approaches
> bloom and compete on their merits?

Yes and that was the decision reached last kernel summit.

The remaining problem is to get AppArmor into a state ready for merging,
which hopefully this review series is doing.
