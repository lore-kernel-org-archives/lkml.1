Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZEZWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZEZWZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759062AbZEZWXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:23:54 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59896 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907AbZEZWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:23:52 -0400
Date: Tue, 26 May 2009 23:23:52 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090526222352.GA1532@sucs.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.9dE.cScGKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <WCcYF-TAbJC.A.9dE.cScGKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 09:31:15PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> Subject		: i915 VT switch with AIGLX causes X lock up
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-21 15:38 (93 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
> 		  http://lkml.org/lkml/2009/4/27/317
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> Patch		: http://patchwork.kernel.org/patch/20197/

Yes this is still here in  2.6.30-rc7-00066-ge2a1b9e ...

-- 
Sitsofe | http://sucs.org/~sits/
