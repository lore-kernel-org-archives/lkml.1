Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZGQXON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZGQXON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 19:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZGQXOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 19:14:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758004AbZGQXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 19:14:09 -0400
Date: Fri, 17 Jul 2009 16:13:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nishimura@mxp.nes.nec.co.jp, menage@google.com
Subject: Re: [BUGFIX][PATCH] cgroup avoid permanent sleep at rmdir v7
Message-Id: <20090717161358.d6deea38.akpm@linux-foundation.org>
In-Reply-To: <20090717023519.GG3576@balbir.in.ibm.com>
References: <20090703093154.5f6e910a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090716145534.07511d67.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717023519.GG3576@balbir.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 08:05:19 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-07-16 14:55:34]:
> 
> > Rebased onto mm-of-the-moment snapshot 2009-07-15-20-57.
> > passed fundamental tests.
> 
> Andrew could you please pick this up, it is an important bugfix and if
> possible needs to go into 2.6.31-rcX. Does anybody object to that or
> should we wait till 2.6.32-rc1?

I marked this as for-2.6.31-rc4.  Unless someone stops me, that's when
I shall send it upwards.

