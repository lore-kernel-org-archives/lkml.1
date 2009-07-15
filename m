Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZGOJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZGOJr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZGOJr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:47:26 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:56862 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZGOJrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:47:25 -0400
Date: Wed, 15 Jul 2009 15:17:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-next@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 6-July 9-July 15 (percpu/x86)
Message-ID: <20090715094720.GA6674@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090706162632.fdde002e.sfr@canb.auug.org.au> <20090706095343.df21d4c9.rdunlap@xenotime.net> <20090709102248.01e2312c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090709102248.01e2312c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2009-07-09 10:22:48]:

> On Mon, 6 Jul 2009 09:53:43 -0700 Randy Dunlap wrote:
> 
> > On Mon, 6 Jul 2009 16:26:32 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20090703:
> > > 
> > > The percpu tree lost all its conflicts but gained another against the tip
> > > tree.
> > 
> > arch/x86/mm/pageattr.c: In function 'cpa_process_alias':
> > arch/x86/mm/pageattr.c:749: error: implicit declaration of function 'pcpu_lpage_remapped'
> > 
> > config attached.
> 
> 
> Still present in 20090709...
> 
still seen in 20090715 with allnoconfig.


					Kamalesh
