Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZCLCDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZCLCDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZCLCCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:02:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39974 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbZCLCCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:02:33 -0400
Date: Thu, 12 Mar 2009 11:01:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 6/5] softlimit document
Message-Id: <20090312110107.c4749a8d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49B86B3A.2050506@cn.fujitsu.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312100112.6f010cae.kamezawa.hiroyu@jp.fujitsu.com>
	<49B86B3A.2050506@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:54:02 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > +    - memory.softlimit_priority.
> > +	- priority of this cgroup at softlimit reclaim.
> > +	  Allowed priority level is 3-0 and 3 is the lowest.
> > +	  If 0, this cgroup will not be target of softlimit.
> > +
> 
> Seems this document is the older one...
> 
Ouch..my merge miss...please ignore this 6/5.

Thanks,
-Kame


