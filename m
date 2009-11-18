Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZKRBl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZKRBl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZKRBl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:41:58 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61773 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbZKRBl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:41:57 -0500
Date: Wed, 18 Nov 2009 10:42:02 +0900 (JST)
Message-Id: <20091118.104202.93202498881578517.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH v2 4/4] perf bench: Modify Makefile for new source file
 mem-memcpy.c
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091117154240.GA30832@elte.hu>
References: <20091118.001801.107761308.mitake@dcl.info.waseda.ac.jp>
	<20091117153717.GA3514@elte.hu>
	<20091117154240.GA30832@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 4/4] perf bench: Modify Makefile for new source file mem-memcpy.c
Date: Tue, 17 Nov 2009 16:42:40 +0100

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > > Subject: [PATCH v2 4/4] perf bench: Modify Makefile for new source file mem-memcpy.c
> > > Date: Wed, 18 Nov 2009 00:15:03 +0900
> > > 
> > > VEERRRYYY SORRY...
> > > 
> > > I sent old files...
> > > I'll send new ones later. It's time to sleep...
> > 
> > No problem - i'll sort it out.
> 
> Looks good here - i've applied it.
> 
> Note, i've created a single commit out of the 4 commits - there's no 
> reason to split up the change into 4 different parts.

Thanks.
I'll send one patch when it is little enough from next time.

     Hitoshi
