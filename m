Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZERHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZERHN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZERHNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:13:17 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:53428 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZERHNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:13:16 -0400
Date: Mon, 18 May 2009 08:13:16 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090518071315.GA26870@sucs.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.iyH.9B0DKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pQ9WADCjgyE.A.iyH.9B0DKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 10:05:57PM +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> Subject		: i915 VT switch with AIGLX causes X lock up
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-21 15:38 (85 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
> 		  http://lkml.org/lkml/2009/4/27/317
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> Patch		: http://patchwork.kernel.org/patch/20197/

Yes, this problem is still here in 2.6.30-rc6-00026-g0f6f49a .

-- 
Sitsofe | http://sucs.org/~sits/
