Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZFBTVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZFBTVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZFBTVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:21:41 -0400
Received: from pearlgates.net ([83.163.47.93]:47765 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFBTVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:21:39 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 15:21:39 EDT
Date: Tue, 2 Jun 2009 21:11:07 +0200
From: Jos van der Ende <seraph@xs4all.nl>
To: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI
 enabled
Message-Id: <20090602211107.388693ef.seraph@xs4all.nl>
In-Reply-To: <20090531105227.178e5397.angel@pearlgates.net>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
	<PkPeJtNB3KO.A.CSH.sWbIKB@chimera>
	<20090531105227.178e5397.angel@pearlgates.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The bug fix in question is this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42beefc00

I did some final testing today.

The problem with the black screen I was having with 2.6.30 seems to have been solved in rc7, X works flawlessly there.

2.6.29.4 and 2.6.29-gentoo-r5 also work just fine with Dave's bug fix in place.


Thanks to everyone who helped! :-)


-- 
Jos van der Ende <seraph@xs4all.nl>
