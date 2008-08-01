Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYHANB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYHANB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYHANBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:01:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYHANBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:01:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 0/6] Container Freezer: Reuse Suspend Freezer
Date: Fri, 1 Aug 2008 15:04:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
References: <20080801050659.924495279@us.ibm.com> <1217567816.25300.197.camel@localhost.localdomain>
In-Reply-To: <1217567816.25300.197.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808011504.03251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of August 2008, Matt Helsley wrote:
> 
> On Thu, 2008-07-31 at 22:06 -0700, Matt Helsley wrote:
> > This patch series introduces a cgroup subsystem that utilizes the swsusp
> > freezer to freeze a group of tasks. It's immediately useful for batch job
> > management scripts. It should also be useful in the future for implementing
> > container checkpoint/restart.
> 
> <snip>
> 
> > Andrew, since I hear Rafael doesn't have time to review these (again) at this
> > time, please consider these patches for -mm.
> 
> 	Argh -- that "(again)" is ripe for misinterpretation! Rafael has
> reviewed and commented on these patches often in the past but, from what
> I hear, lacks the time to do so now. Hence I'm sending these to -mm.
> 
> 	Sorry about the wording Rafael.

No problem.

If there are not too many new regressions reported today, I'll have a look at
the patches in the evening.

Thanks,
Rafael
