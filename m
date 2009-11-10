Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZKJIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZKJIXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZKJIXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:23:54 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59790 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbZKJIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:23:54 -0500
Date: Tue, 10 Nov 2009 17:23:57 +0900 (JST)
Message-Id: <20091110.172357.877383598482614594.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       paulus@samba.org
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style
 formatting
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091110080135.GA32322@elte.hu>
References: <20091110035812.GB29454@elte.hu>
	<20091110.165102.386189748263321818.mitake@dcl.info.waseda.ac.jp>
	<20091110080135.GA32322@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style formatting
Date: Tue, 10 Nov 2009 09:01:35 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > And I have a question.
> > In tools/perf/command-list.txt, there is the word "mainporcelain".
> > What does this mean?
> 
> tools/perf/ inherited the command-list.txt code from the Git project:
> 
>   git://git.kernel.org/pub/scm/git/git.git
> 
> in Git talk, 'porcelain' is the pretty stuff humans use. 'plumbing' is 
> the lowlevel stuff humans dont get to see.
> 
> 'mainporcelain' are the major commands you get listed when you type 
> 'perf' (or 'git').

Thanks, I got it!

> 
> ( i've Cc:-ed the Git list as i never saw any real formal definition for
>   this anywhere, maybe i got this wrong :-)
> 
> > Of course I searched this word on my dictionary, but cannot got an answer.
> > I'm preparing the initial document for perf-bench.
> > Can I add perf-bench with mainporcelain to command-list.txt?
> 
> yeah, i'd suggest to do that - that will make 'perf bench' show up in 
> 'perf' output.

I'll describe perf bench as mainporcelain command, thanks.
