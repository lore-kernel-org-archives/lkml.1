Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZJFTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZJFTF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZJFTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:05:56 -0400
Received: from csl.cornell.edu ([128.84.224.10]:1536 "EHLO
	vlsi.csl.cornell.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbZJFTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:05:56 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 15:05:56 EDT
Date: Tue, 6 Oct 2009 14:57:41 -0400 (EDT)
From: Vince Weaver <vince@csl.cornell.edu>
To: eranian@gmail.com
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, perfmon2-devel@lists.sf.net,
       mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [perfmon2] [PATCH 2/2] perf_events: add event constraints support
 for Intel processors
In-Reply-To: <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
Message-ID: <20091006145408.Q25434@stanley.csl.cornell.edu>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
 <1254840129-6198-2-git-send-email-eranian@gmail.com>
 <1254840129-6198-3-git-send-email-eranian@gmail.com> <1254846544.21044.298.camel@laptop>
 <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, stephane eranian wrote:

> On Tue, Oct 6, 2009 at 6:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2009-10-06 at 16:42 +0200, Stephane Eranian wrote:
> 
> > I don't actually have that hardware, so I can't test it.
> >
> I don't have that either but I can find people who have that.

I have Yonah hardware and would be glad to run tests.

For what it's worth, the perfmon2 Yonah support (at least on the laptop I 
have) stopped working after 2.6.23.  It looked like a problem with 
interrupts not being delivered properly.  I never had time to track down 
if it was a perfmon2 issue or a generic kernel issue.  It was still broken 
as of 2.6.29

Vince
