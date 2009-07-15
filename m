Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGOKCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGOKCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZGOKCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:02:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:36506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZGOKCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:02:49 -0400
Message-ID: <4A5DA937.6040605@kernel.org>
Date: Wed, 15 Jul 2009 19:02:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <htejun@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for July 6-July 9-July 15 (percpu/x86)
References: <20090706162632.fdde002e.sfr@canb.auug.org.au>	<20090706095343.df21d4c9.rdunlap@xenotime.net>	<20090709102248.01e2312c.randy.dunlap@oracle.com>	<20090715094720.GA6674@linux.vnet.ibm.com> <20090715195807.f0d1a7ea.sfr@canb.auug.org.au>
In-Reply-To: <20090715195807.f0d1a7ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Jul 2009 10:02:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
>>> Still present in 20090709...
>>>
>> still seen in 20090715 with allnoconfig.
> 
> Any ideas?

Getting the tree now.  Probably broken build with !SMP.  Will report
back as soon as I know more.

Thanks.

-- 
tejun
