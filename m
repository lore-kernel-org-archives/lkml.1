Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZGAALi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZGAALi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZGAALb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:11:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45953 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZGAALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:11:31 -0400
Date: Wed, 1 Jul 2009 09:09:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Paul Menage <menage@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
Message-Id: <20090701090959.4cbdb03e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	<20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
	<20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 08:40:37 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 30 Jun 2009 09:18:03 -0700, Paul Menage <menage@google.com> wrote:
> > On Tue, Jun 30, 2009 at 2:23 AM, KAMEZAWA
> > Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > This patch is _not_ tested by Nishimura.
> > 
> > True, but it's functionally identical to, and simpler than, the one
> > that was tested.
> > 
> I agree.
> I'll test with both of these patches folded.
> 
Hm,ok. I'll post merged one today.
But I don't like cosmeticized bugfix patch ;(

-Kame

> 
> Daisuke Nishimura.
> 

