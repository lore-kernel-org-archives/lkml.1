Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbXHBLPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbXHBLPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXHBLPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:15:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:57515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbXHBLPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:15:36 -0400
Subject: Re: cpufreq.c:(.text+0xaf178): undefined reference to
	`cpufreq_gov_performance'
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070801165704.a26961b7.akpm@linux-foundation.org>
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com>
	 <20070801165704.a26961b7.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 13:15:32 +0200
Message-Id: <1186053332.18821.465.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 16:57 -0700, Andrew Morton wrote:
> On Wed, 1 Aug 2007 16:31:46 -0700
> "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `__cpufreq_governor':
> > cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
> > cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> One for Thomas, I expect.

Miles, could you send me or point me to the offending .config file.

Thanks,

   Thomas

