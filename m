Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYJUQoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYJUQoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYJUQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:43:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34640 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYJUQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:43:38 -0400
Subject: Re: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.28
From: Marcel Holtmann <marcel@holtmann.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48F73F92.8030201@csr.com>
References: <48EF45BC.1020805@csr.com>
	 <20081014130251.aa008a5e.akpm@linux-foundation.org>
	 <48F5E704.1070808@csr.com>  <48F73F92.8030201@csr.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 18:44:33 +0200
Message-Id: <1224607473.9386.94.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > I can fix up some of the issues in the next couple of days (use
> > time_after() and kcalloc()).  Could these subsystems then be merged?
> 
> Fixed.
> 
> > The printk_ratelimit() will take a bit longer.
> 
> I fixed some of these.  I need to think more on what's best to do with
> the remaining ones.
> 
> Linus,
> 
> Can you pull these subsystems now from?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

you might have to send a new pull request within a new thread. I think
that Linus missed this one and I would like to see getting UWB support
finally merged.

Regards

Marcel


