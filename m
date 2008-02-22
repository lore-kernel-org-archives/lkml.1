Return-Path: <linux-kernel-owner+w=401wt.eu-S1763301AbYBVDMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763301AbYBVDMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYBVDMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:12:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60176 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbYBVDMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:12:01 -0500
Date: Fri, 22 Feb 2008 12:09:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Cc: kosaki.motohiro@jp.fujitsu.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       John Stoffel <john@stoffel.org>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080221235527.GD25977@elf.ucw.cz>
References: <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com> <20080221235527.GD25977@elf.ucw.cz>
Message-Id: <20080222120758.AE67.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I think one reason of many people easy confusion is caused by bad menu
> > hierarchy.
> > I popose mem-cgroup move to child of cgroup and resource counter
> > (= obey denend on).
> 
> > +config CGROUP_MEM_CONT
> > +	bool "Memory controller for cgroups"
> 
> Memory _resource_ controller for cgroups?

Ahhh
my proposal only change menu hierarchy.
I don't know best name and i hope avoid rename discussion ;-)

Thanks.


- kosaki

