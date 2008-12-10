Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYLJBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYLJBIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYLJBIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:08:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56690 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYLJBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:08:13 -0500
Date: Wed, 10 Dec 2008 10:07:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: Documentation for internal
 implementation
Message-Id: <20081210100717.0428a49e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <493F151B.50800@cn.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200413.d842ede4.kamezawa.hiroyu@jp.fujitsu.com>
	<20081210092735.25d9d618.kamezawa.hiroyu@jp.fujitsu.com>
	<493F151B.50800@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 09:02:19 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Paul, Balbir
> > 
> > I have a question.
> > 
> > Why cgroup's documentation directroy is divided into 2 places ?
> > 
> > 	Documentation/cgroups
> > 	             /controllers
> > 
> 
> Documentation/cgroups was created by Matt Helsley, when he added freezer-subsystem.txt,
> and he also moved cgroups.txt to the new Documentation/cgroups.
> 
> > If no strong demands, I'd like to remove "controllers" directroy and move
> 
> I prepared a patch to do so long ago, but didn't ever send it out.
> 
Thank you for clarification. Then, it seems there are no special meanings.
I think people tends to recognize codes as "cgroups" rather than "controllers".
I'd like to prepare a patch after sending this update out.
If you do, I'll adjust my updates.

Thanks,
-Kame

