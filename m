Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZKQPmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZKQPmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZKQPms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:42:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36003 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZKQPms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:42:48 -0500
Date: Tue, 17 Nov 2009 16:42:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH v2 4/4] perf bench: Modify Makefile for new source file
 mem-memcpy.c
Message-ID: <20091117154240.GA30832@elte.hu>
References: <20091118.001135.11492872.mitake@dcl.info.waseda.ac.jp>
 <1258470903-29577-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091118.001801.107761308.mitake@dcl.info.waseda.ac.jp>
 <20091117153717.GA3514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117153717.GA3514@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Subject: [PATCH v2 4/4] perf bench: Modify Makefile for new source file mem-memcpy.c
> > Date: Wed, 18 Nov 2009 00:15:03 +0900
> > 
> > VEERRRYYY SORRY...
> > 
> > I sent old files...
> > I'll send new ones later. It's time to sleep...
> 
> No problem - i'll sort it out.

Looks good here - i've applied it.

Note, i've created a single commit out of the 4 commits - there's no 
reason to split up the change into 4 different parts.

	Ingo
