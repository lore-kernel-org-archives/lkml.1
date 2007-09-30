Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXI3Vpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXI3Vpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXI3Vpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:45:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbXI3Vpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:45:45 -0400
Date: Sun, 30 Sep 2007 14:44:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-git4: Known regressions from 2.6.22
In-Reply-To: <20070930143012.ddff564c.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.999.0709301443100.3579@woody.linux-foundation.org>
References: <200709302305.09861.rjw@sisk.pl>
 <20070930143012.ddff564c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Sep 2007, Randy Dunlap wrote:
> On Sun, 30 Sep 2007 23:05:09 +0200 Rafael J. Wysocki wrote:
> > 
> > Subject:	build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
> > Submitter:	Toralf Förster <toralf.foerster@gmx.de>
> > References:	http://lkml.org/lkml/2007/9/11/150
> > 		http://bugzilla.kernel.org/show_bug.cgi?id=9077
> > Patch:		http://bugzilla.kernel.org/attachment.cgi?id=12963&action=view
> 
> I'm told that this is already patched in the net-2.6.24 git tree,
> but it should be merged for 2.6.23 IMO.

Jeff, John?

Build errors like this may not be a huge deal, but the fix looks 
worthwhile anyway, so is there any reason this hasn't been sent upstream?

		Linus
