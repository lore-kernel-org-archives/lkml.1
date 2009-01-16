Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZAPDDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZAPDDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbZAPDDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:03:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51238 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbZAPDDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:03:34 -0500
Date: Fri, 16 Jan 2009 12:02:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: matthltc@us.ibm.com, Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090116120227.def88bc8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090116114502.b3bd565d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	<20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	<1232072445.7955.40.camel@localhost>
	<20090116114502.b3bd565d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 11:45:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 15 Jan 2009 18:20:45 -0800
> Matthew Helsley <matthltc@us.ibm.com> wrote:
> I think
>   - Paul's suggestion sounds attractive. But I can't see fundamental differences
>     from user's side between "implemented as subsys" and "implemetned as cgroup's
>     feature". I feel it's easier for user's cgroup library to handle subsys rather
>     than "we can mount it anywhere, multiple times!".
>     Flexiblity doesn't means it's easy to use.
I should consider more....

mutiple mount point means that the process can belongs to multiple nickname
groups. oh yes, seems worth to try.


Thanks,
-Kame

