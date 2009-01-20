Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZATHbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZATHbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZATHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:30:51 -0500
Received: from eazy.amigager.de ([213.239.192.238]:53166 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZATHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:30:50 -0500
Date: Tue, 20 Jan 2009 08:30:46 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Thomas Renninger <trenn@suse.de>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad
	X61s
Message-ID: <20090120073046.GA2534@x61>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.nnC.3JRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX2gZ6Cy9nC.A.nnC.3JRdJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 22:45:41 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12401
> Subject		: 2.6.28 regression: xbacklight broken on ThinkPad X61s
> Submitter	: Tino Keitel <tino.keitel@gmx.de>
> Date		: 2009-01-05 8:39 (15 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=22c13f9d8179f4c9caecfcb60a95214562b9addc
> References	: http://marc.info/?l=linux-kernel&m=123114479110314&w=4

I tried 2.6.28.1 and xbacklight works fine, so this regression is
solved.

Regards,
Tino
