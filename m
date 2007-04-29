Return-Path: <linux-kernel-owner+w=401wt.eu-S1161535AbXD2XPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161535AbXD2XPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161542AbXD2XPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:15:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161535AbXD2XOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:14:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: Linux 2.6.21
Date: Mon, 30 Apr 2007 01:19:17 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070428224904.GE3468@stusta.de> <20070429211028.GT3468@stusta.de> <20070429235147.06a94dfa.diegocg@gmail.com>
In-Reply-To: <20070429235147.06a94dfa.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704300119.18474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 23:51, Diego Calleja wrote:
> El Sun, 29 Apr 2007 23:10:28 +0200, Adrian Bunk <bunk@stusta.de> escribió:
> 
> > What exactly is the purpose of the 2.6.21 regressions list in the Wiki?
> 
> AFAIK, submitting its contents to the list periodically CCing the developers,
> like you did with your lists.
> 
> If developers care to fix it or not or how much Linus cares about that list before
> releasing a new version is another question. I think it's useful because it makes
> those bugs look more important than the 1600 stored in the bugzilla...it won't
> help to fix those 1600, but it attracts some attention over the "release critical"
> ones and encourages developers to fix them, even if not all of them get fixed.
> 
> I don't think you can do many other things to get as much bugs fixed as possible,
> unless we reward bug fixers with weekends in the Playboy mansion. I think the
> fundamental question here is: is there a way to make hackers follow and fix _all_
> the bugs? I'd love it was possible, but AFAIK all the projects that have tried to
> be ultra-stable and have adopted a policy to fullfill such goal have fallen behind
> of competing projects that cared more about working in improving their software.

Apart from this many bugs are found and get fixed in the process of developing
new code, so the 'ultra stable' approach is not really practical.

Greetings,
Rafael
