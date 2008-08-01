Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYHAFRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYHAFRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHAFQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:16:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56521 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYHAFQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:16:56 -0400
Subject: Re: [PATCH 0/6] Container Freezer: Reuse Suspend Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20080801050659.924495279@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 31 Jul 2008 22:16:56 -0700
Message-Id: <1217567816.25300.197.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-31 at 22:06 -0700, Matt Helsley wrote:
> This patch series introduces a cgroup subsystem that utilizes the swsusp
> freezer to freeze a group of tasks. It's immediately useful for batch job
> management scripts. It should also be useful in the future for implementing
> container checkpoint/restart.

<snip>

> Andrew, since I hear Rafael doesn't have time to review these (again) at this
> time, please consider these patches for -mm.

	Argh -- that "(again)" is ripe for misinterpretation! Rafael has
reviewed and commented on these patches often in the past but, from what
I hear, lacks the time to do so now. Hence I'm sending these to -mm.

	Sorry about the wording Rafael.

Cheers,
	-Matt Helsley

