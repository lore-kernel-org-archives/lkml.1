Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZEQOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZEQOR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZEQORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:17:48 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63289 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZEQORr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:17:47 -0400
To: rostedt@goodmis.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: ftrace 2.6.30-rc4: possible circular locking dependency
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200905082255.BGE18711.LJQVStFHOFOOMF@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.00.0905081000000.28378@gandalf.stny.rr.com>
	<20090508151044.GC29974@elte.hu>
	<alpine.DEB.2.00.0905081124350.28378@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905081124350.28378@gandalf.stny.rr.com>
Message-Id: <200905172317.CHB04637.tMJFVOSQLOHOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 17 May 2009 23:17:48 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Fri, 8 May 2009, Ingo Molnar wrote:
> 
> > Would be nice to have a non-conflicting version against latest -git 
> > - which Tetsuo could test as well, and which i could apply if the 
> > test is successful.
> 
> OK, I'll write up a patch.
> 
Is the patch ready? I want to try the patch in my 2.6.30-rc6 environment.
