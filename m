Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZIJUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZIJUR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZIJUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:17:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZIJUR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:17:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
Date: Thu, 10 Sep 2009 22:18:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
References: <20090910192153.GA584@redhat.com>
In-Reply-To: <20090910192153.GA584@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102218.40143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Thursday 10 September 2009, Oleg Nesterov wrote:
> (my apologies to those who see this twice).
> 
> 
> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
> depends on 2nd.
> 
> These patches change the code which I don't really understand, please
> review.
> 
> 
> As for the 3rd patch, it replaces
> 
> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> in -mm tree. Imho the new patch is more simple and clean, but of course
> this is subjective and I am biased.

The patches look good to me FWIW.

Thanks a lot for taking care of this!

Rafael
