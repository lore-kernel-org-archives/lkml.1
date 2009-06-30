Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbZF3X6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbZF3X6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZF3X56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:57:58 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61701 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZF3X55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:57:57 -0400
Date: Wed, 1 Jul 2009 08:40:37 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
Message-Id: <20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	<20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 09:18:03 -0700, Paul Menage <menage@google.com> wrote:
> On Tue, Jun 30, 2009 at 2:23 AM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > This patch is _not_ tested by Nishimura.
> 
> True, but it's functionally identical to, and simpler than, the one
> that was tested.
> 
I agree.
I'll test with both of these patches folded.


Daisuke Nishimura.
