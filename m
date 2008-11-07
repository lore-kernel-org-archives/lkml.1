Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYKGBNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYKGBNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYKGBNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:13:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55555 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYKGBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:13:24 -0500
Date: Fri, 7 Nov 2008 10:12:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 7/6] memcg: add atribute (for change bahavior 
 ofrmdir)
Message-Id: <20081107101245.2ac46e75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6941.10.75.179.62.1225981828.squirrel@webmail-b.css.fujitsu.com>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<49129493.9070103@linux.vnet.ibm.com>
	<20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
	<4912F53A.2070407@linux.vnet.ibm.com>
	<6941.10.75.179.62.1225981828.squirrel@webmail-b.css.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 23:30:28 +0900 (JST)
"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Balbir Singh said:
> > KAMEZAWA Hiroyuki wrote:
> >> BTW, cost of movement itself is not far from cost for force_empty.
> >>
> >> If you can't find why "forget" is bad, please consider one more day.
> >
> > The attributes seem quite reasonable, I've taken a quick look, not done a
> > full
> > review or test.
> >
> Thanks, I'll go ahead in this direction.
> 
It seems Andrew picked account_move patch into his queue. I'll post this as
add-on to mmotm, in the next week. patch-for-test can be posted in hours if
I work well...

Thanks,
-Kame

