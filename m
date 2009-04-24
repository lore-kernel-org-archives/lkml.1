Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZDXInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZDXInT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZDXInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:43:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZDXInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:43:06 -0400
Date: Fri, 24 Apr 2009 10:46:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
Message-ID: <20090424084647.GI13896@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150657.61C4E1D046E@basil.firstfloor.org> <1240479838.6842.555.camel@yhuang-dev.sh.intel.com> <49F1077A.5030801@jp.fujitsu.com> <1240535513.6842.561.camel@yhuang-dev.sh.intel.com> <49F150BA.9040407@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F150BA.9040407@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 10:40:10PM -0700, H. Peter Anvin wrote:
> Huang Ying wrote:
> > On Fri, 2009-04-24 at 08:27 +0800, Hidetoshi Seto wrote:
> >> Huang Ying wrote:
> >>
> >> Or, should this patch be applied after committing some of Andi's patches?
> >> It means this patch targets a bug in Andi's patch set and the bug is not
> >> in 2.6.30-rc* yet.
> > 
> > Yes. I think you are right. I fix a "bug" that doesn't exist.
> > 
> 
> Thanks for catching that now :)

Sorry we still need it I think, see previous email.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
