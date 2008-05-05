Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYEEVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYEEVSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYEEVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:18:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbYEEVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:18:03 -0400
Date: Mon, 5 May 2008 14:18:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: + git-net-git-rejects.patch added to -mm tree
Message-Id: <20080505141800.4283823e.akpm@linux-foundation.org>
In-Reply-To: <20080505.140450.48875249.davem@davemloft.net>
References: <200805051905.m45J5eG7032280@imap1.linux-foundation.org>
	<20080505.125118.101401893.davem@davemloft.net>
	<20080505130911.52b22577.akpm@linux-foundation.org>
	<20080505.140450.48875249.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 14:04:50 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 5 May 2008 13:09:11 -0700
> 
> > I noticed that there were rather a lot of changes in
> > git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> > which are not in linux-next, perhaps due to time lag.
> 
> Andrew, I think you simply have to "let go" of one side or
> the other.
> 
> If you're going to base on top of linux-next, then let it run
> it's course and don't try to suck in the GIT trees on top
> of that which linux-next takes already.

It could be that this is what I end up doing - I just don't know yet.

One downside of the linux-next lag is that I can end up merging patches
which others have already merged (more than usual).

I'm still working these things out..
