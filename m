Return-Path: <linux-kernel-owner+w=401wt.eu-S1161397AbXD2V0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161397AbXD2V0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161430AbXD2V0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:26:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40189 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161397AbXD2V0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:26:46 -0400
Date: Sun, 29 Apr 2007 23:26:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, torvalds@linux-foundation.org, bunk@stusta.de,
       diegocg@gmail.com, cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
Message-ID: <20070429212643.GA32750@one.firstfloor.org>
References: <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429.130143.21926295.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429.130143.21926295.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I reported a bug that eats people's hard disks due to a bug
> in the X.ORG PCI support code on sparc, NOBODY has fixed
> the bug in 2 years even though a full bugzilla entry with
> even a full patch fix is in there.

Well but at least they could find it again if they wanted.
If you sent it by email and it had gotten lost for some reason
(nobody interested, which seems to be the real issue here) then
it would be lost forever.

Of course a database is not a silver bullet by itself, it still
needs people to use it correctly and then actually work on the bugs.

A database just a tool to move some work humans are bad at (keeping track 
of a lot of data and deriving trends out of it) to a a computer which is 
much better at this.

-Andi
