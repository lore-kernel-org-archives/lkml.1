Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZERLqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZERLqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZERLqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:46:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46740 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbZERLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:46:22 -0400
Date: Mon, 18 May 2009 20:44:21 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [rfc] object collection tracing (was: [PATCH 5/5] proc: export more page flags in /proc/kpageflags)
Cc: kosaki.motohiro@jp.fujitsu.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090517133659.GD3254@localhost>
References: <20090512130110.GA6255@nowhere> <20090517133659.GD3254@localhost>
Message-Id: <20090518204242.0A07.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


> > Could you send us the (sob'ed) patch you made which implements this.
> > I could try to adapt it to object collection.
> 
> Attached for your reference. Be aware that I still have plans to
> change it in non trivial way, and there are ongoing works by Nick(on
> inode_lock) and Jens(on s_dirty) that can create merge conflicts.
> So basically it is not a right time to do the adaption.

if you can make object collection based filecache viewer, could you
please cc me? I guess I can review it in mm part.

thanks.


