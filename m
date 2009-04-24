Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZDXIcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZDXIcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZDXIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:31:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32895 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZDXIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:31:50 -0400
Date: Fri, 24 Apr 2009 10:35:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
Message-ID: <20090424083532.GF13896@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150657.61C4E1D046E@basil.firstfloor.org> <1240479838.6842.555.camel@yhuang-dev.sh.intel.com> <49F0D45D.3000706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F0D45D.3000706@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 01:49:33PM -0700, H. Peter Anvin wrote:
> Huang Ying wrote:
> >Add some description for the patch, hope that to be more clear.
> 
> The patch description makes sense.  I cannot, however, make head or tail 
> out of the subject line or how it is related to the patch at all?
> 
> I have rewritten it to "always panic on tolerant == 0", ok with everyone?

Ok for me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
