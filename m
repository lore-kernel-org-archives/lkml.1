Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZH0ViQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZH0ViQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZH0ViP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:38:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbZH0ViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:38:13 -0400
Date: Thu, 27 Aug 2009 14:36:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: elendil@planet.nl, zajec5@gmail.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-acpi@vger.kernel.org, kernel-testers@vger.kernel.org,
       torvalds@linux-foundation.org, rui.zhang@intel.com, lenb@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090827143653.52308d6d.akpm@linux-foundation.org>
In-Reply-To: <200908272023.21288.rusty@rustcorp.com.au>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<200908261833.37310.elendil@planet.nl>
	<20090826123647.e60d9555.akpm@linux-foundation.org>
	<200908272023.21288.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 20:23:20 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> > My linux-next repair job:
> 
> OK, I've dropped these from my tree entirely to avoid more problems.
> 
> Can you take them?  They're not really at home in my tree.
> 
> arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
> misc:work_on_cpu-acpi.patch
> misc:work_on_cpu-acpi-fix.patch
> misc:work_on_cpu-dcdbas.patch
> 
> You can fetch them from http://ozlabs.org/~rusty/kernel/rr-latest/
> 
> (You'll want to rename the last three something sane...)

Those patches are already in today's linux-next so I can't carry them.

Please email them over in the traditional fashion once that situation
has sorted itself out?

