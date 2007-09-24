Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbXIXV4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbXIXV4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXIXV42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:56:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXIXV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:56:27 -0400
Date: Mon, 24 Sep 2007 14:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [git] CFS-devel, latest code
Message-Id: <20070924145530.5b09acd9.akpm@linux-foundation.org>
In-Reply-To: <20070924214537.GA18980@elte.hu>
References: <20070924214537.GA18980@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 23:45:37 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> The latest sched-devel.git tree can be pulled from:
>  
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

I'm pulling linux-2.6-sched.git, and it's oopsing all over the place on
ia64, and Lee's observations about set_leftmost()'s weirdness are
pertinent.

Should I instead be pulling linux-2.6-sched-devel.git?

