Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZGWANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZGWANt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZGWANs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:13:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZGWANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:13:48 -0400
Date: Wed, 22 Jul 2009 17:12:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       hugh.dickins@tiscali.co.uk, avi@redhat.com,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: Re: [PATCH 0/2] ZERO PAGE again v4.
Message-Id: <20090722171245.d5b3a108.akpm@linux-foundation.org>
In-Reply-To: <20090723085137.b14fe267.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
	<20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
	<20090723085137.b14fe267.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 08:51:37 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 16 Jul 2009 18:01:34 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > 
> > Rebased onto  mm-of-the-moment snapshot 2009-07-15-20-57.
> > And modifeied to make vm_normal_page() eat FOLL_NOZERO, directly.
> > 
> > Any comments ?
> > 
> 
> A week passed since I posted this.

I'm catching up at a rate of 2.5 days per day.  Am presently up to July
16.  I never know whether to work through it forwards or in reverse.

Geeze you guys send a lot of stuff.  Stop writing new code and go fix
some bugs!

> It's no problem to keep updating this
> and post again. But if anyone have concerns, please notify me.
> I'll reduce CC: list in the next post.

ok...
