Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYAVPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYAVPyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYAVPxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:53:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbYAVPxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:53:45 -0500
Date: Tue, 22 Jan 2008 16:53:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel BUG while bootup
Message-ID: <20080122155329.GA30119@elte.hu>
References: <20080122135800.GA6084@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122135800.GA6084@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.2
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.2 required=5.9 tests=BAYES_00,URIBL_GREY autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.2 URIBL_GREY             Contains an URL listed in the URIBL greylist
	[URIs: googlepages.com]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sudhir Kumar <skumar@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> I found a Bug at the very start of booting rc8-mm1 kernel on my 
> machine. Following is the info of my machine: uname -a Linux 
> x330d.in.ibm.com 2.6.24-rc6 #3 SMP Tue Jan 15 17:24:05 NPT 2008 i686 
> i686 i386 GNU/Linux
> 
> Since I could capture a jpeg image of the boot message so I have put 
> it at
> 
> http://imsudhirkumar.googlepages.com/home

i think this is an early bootup crash that has been resolved in x86.git.

	Ingo
