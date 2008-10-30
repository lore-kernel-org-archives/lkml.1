Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYJ3Hda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYJ3Hda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYJ3HdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:33:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbYJ3HdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:33:21 -0400
Date: Thu, 30 Oct 2008 00:32:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix invalid cgrp->dentry before cgroup has been
 completely removed
Message-Id: <20081030003226.33bad22a.akpm@linux-foundation.org>
In-Reply-To: <490960EF.7020500@cn.fujitsu.com>
References: <490960EF.7020500@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 15:23:27 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> This fixes oops when reading /proc/sched_debug.

In which kernel versions?  The patch applies to 2.6.27 - should it be
aplied to 2.6.27.x?  Earlier?

Thanks.
