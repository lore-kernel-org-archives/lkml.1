Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbXJORLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbXJORLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765392AbXJORKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:10:45 -0400
Received: from mga05.intel.com ([192.55.52.89]:49551 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765317AbXJORKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,278,1188802800"; 
   d="scan'208";a="346740363"
Date: Mon, 15 Oct 2007 10:04:11 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015170411.GB18550@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071014190128.6e3cdb44@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> The kernel newbies community often gets inquiries from CS students who
> need a project for their studies and would like to do something with
> the Linux kernel, but would also like their code to be useful to the
> community afterwards.
> 
> In order to make it easier for them, I am trying to put together a
> page with projects that:
> - Are self contained enough that the students can implement the
>   project by themselves, since that is often a university requirement.
> - Are self contained enough that Linux could merge the code (maybe
>   with additional changes) after the student has been working on it
>   for a few months.
> - Are large enough to qualify as a student project, luckily there is
>   flexibility here since we get inquiries for anything from 6 week
>   projects to 6 month projects.
> 
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):
> 
> http://kernelnewbies.org/KernelProjects

Is there already a make config option that will do a good job at setting
a default .config file based on what is already running on a system?  

I get tiered of trimming down my .config for my laptop build so it takes
less than 30min to build a kernel.

Bonus credit to additional "expert" options (like those powertop puts
out) for target uses, laptop, HPC, home file share, embedded targets....

Oh, and lets make the expert configs easily extensible.


--mgross


> 
> thanks,
> 
> Rik
> -- 
> "Debugging is twice as hard as writing the code in the first place.
> Therefore, if you write the code as cleverly as possible, you are,
> by definition, not smart enough to debug it." - Brian W. Kernighan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
