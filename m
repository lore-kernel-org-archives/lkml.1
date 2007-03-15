Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXCOTHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXCOTHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbXCOTHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:07:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXCOTHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:07:05 -0400
Date: Thu, 15 Mar 2007 11:06:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@in.ibm.com
Cc: rdunlap@xenotime.net, jlan@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: taskstats accounting info
Message-Id: <20070315110655.5a815f2e.akpm@linux-foundation.org>
In-Reply-To: <45F7E818.7010608@in.ibm.com>
References: <Pine.LNX.4.58.0703140503250.28169@shark.he.net>
	<45F7E818.7010608@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 17:48:32 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> Randy.Dunlap wrote:
> > Hi,
> > 
> > Documentation/accounting/delay-accounting.txt says that the
> > getdelays program has a "-c cmd" argument, but that option
> > does not seem to exist in Documentation/account/getdelays.c.
> > 
> > Do you have an updated version of getdelays.c?
> > If not, please correct that documentation.
> > 
> 
> Yes, I did, but then I changed my laptop. I should have it archived
> at some place, I'll dig it out or correct the documentation.
> 
> > Is getdelays.c the best available example of a program
> > using the taskstats netlink interface?
> > 
> 
> It's the most portable example, since it does not depend on libnl.

err, what is libnl?

If there exists some real userspace infrastructure which utilises
taskstats, can we please get a referece to it into the kernel
Documentation?  Perhaps in the TASKSTATS Kconfig entry, thanks.

