Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXI3Vci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXI3Vci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXI3Vcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:32:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41205 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXI3Vca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:32:30 -0400
Date: Sun, 30 Sep 2007 14:30:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-git4: Known regressions from 2.6.22
Message-Id: <20070930143012.ddff564c.randy.dunlap@oracle.com>
In-Reply-To: <200709302305.09861.rjw@sisk.pl>
References: <200709302305.09861.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 23:05:09 +0200 Rafael J. Wysocki wrote:

> Hi,
> 
> 
> Subject:	build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
> Submitter:	Toralf Förster <toralf.foerster@gmx.de>
> References:	http://lkml.org/lkml/2007/9/11/150
> 		http://bugzilla.kernel.org/show_bug.cgi?id=9077
> Patch:		http://bugzilla.kernel.org/attachment.cgi?id=12963&action=view

I'm told that this is already patched in the net-2.6.24 git tree,
but it should be merged for 2.6.23 IMO.

---
~Randy
