Return-Path: <linux-kernel-owner+w=401wt.eu-S1763407AbYESUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763407AbYESUjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761231AbYESUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:39:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868AbYESUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:39:02 -0400
Date: Mon, 19 May 2008 13:38:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
Cc: randy.dunlap@ORACLE.COM, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: -mm merge plans for 2.6.26
Message-Id: <20080519133841.92de7f90.akpm@linux-foundation.org>
In-Reply-To: <8779236.1211228793416.JavaMail.oracle@acsmt301.oracle.com>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	<20080516170310.35d7b407.randy.dunlap@oracle.com>
	<20080516172816.9d98c0f2.akpm@linux-foundation.org>
	<482E3DDA.7050708@oracle.com>
	<482E5F80.7040206@oracle.com>
	<8779236.1211228793416.JavaMail.oracle@acsmt301.oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 15:26:33 -0500 (CDT)
Randy Dunlap <RANDY.DUNLAP@ORACLE.COM> wrote:

> > > Oh yeah.  I think that this was fixed by
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b11caa7c7063ea92a0a58115d3fc6d038ed89510 
> > > 
> > > but I'll check/verify/confirm that.
> > > 
> > 
> > Yes, it builds fine now (built against 2.6.26-rc2-git5).
> 
> Andrew,
> Will you merge this now?

It's had no public testing because I disabled it in config, so it looks
like a 2.6.27 thing to me.

>  or do you want me to see about Sam merging it?
> or something else?

I'll move it into my send-to-Sam queue.
