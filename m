Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXENVPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXENVPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXENVPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:15:17 -0400
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:3643 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755443AbXENVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:15:15 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: tglx@linutronix.de
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
Date: Mon, 14 May 2007 22:15:08 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <200705140217.11515.s0348365@sms.ed.ac.uk> <1179138368.22481.334.camel@localhost.localdomain>
In-Reply-To: <1179138368.22481.334.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142215.08910.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 11:26:08 Thomas Gleixner wrote:
> I'm pleased to announce an updated version of the x86_64 highres/dyntick
> support patches against 2.6.22-rc1:
[snip]
> - Various fixups from Chris Wright
> - TSC calibration fix (pointed out by Alistair John Strachan)
>
> Comments, bugreports, patches are welcome as ususal

Neither of the bugs I reported appear to be fixed.

I took a clean git tree from the 2.6.22-rc1 tag and patched with this version; 
my CPU MHz and dmesg counter still appear to be broken (v3 was used).

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
