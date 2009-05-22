Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZEVSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZEVSS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZEVSST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:18:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37194 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZEVSSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:18:18 -0400
Message-ID: <4A16EC61.5070307@us.ibm.com>
Date: Fri, 22 May 2009 11:18:09 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip-core tree with Linus' tree
References: <20090521113902.3deb5031.sfr@canb.auug.org.au> <4A14D0FF.60202@us.ibm.com>	<20090522101939.0cba91da.sfr@canb.auug.org.au> <20090522155050.91e025e3.sfr@canb.auug.org.au>
In-Reply-To: <20090522155050.91e025e3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Darren, Thomas,
> 
> On Fri, 22 May 2009 10:19:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> I have made the changes you suggested for today since the -tip stuff has
>                                                                        ^^^
> has not
> 
>> filtered through yet.
> 
> The resolution patch now looks like below.

Looks right at a quick glance.  I just updated linux-2.6-tip and checked 
the "auto-core-next" branch.  I appears to have the necessary 
changes.... I believe since merge 74869023169c6b85383abc66877154a582b35798.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
