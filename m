Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZGGCNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZGGCNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZGGCMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:12:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:23909 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbZGGCMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:12:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,359,1243839600"; 
   d="scan'208";a="428034833"
Date: Tue, 7 Jul 2009 10:12:54 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       Karsten Mehrhoff <kawime@gmx.de>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [Bug #13318] AGP doesn't work anymore on nforce2
Message-ID: <20090707021254.GA25184@sli10-desk.sh.intel.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.PDB.4BpUKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bXZeuxPQAWE.A.PDB.4BpUKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:00:36AM +0800, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
> Subject		: AGP doesn't work anymore on nforce2
> Submitter	: Karsten Mehrhoff <kawime@gmx.de>
> Date		: 2009-04-30 8:51 (68 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
> References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
> Handled-By	: Shaohua Li <shaohua.li@intel.com>
Can anybody else help look at this issue? I really have no idea why this could
happens.

Thanks,
Shaohua
