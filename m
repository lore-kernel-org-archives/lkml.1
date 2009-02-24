Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZBXG47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZBXG47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZBXG4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:56:51 -0500
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:47179 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZBXG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:56:50 -0500
Message-ID: <49A39A2D.7020007@numericable.fr>
Date: Tue, 24 Feb 2009 07:56:45 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.WIF.xpzoJB@chimera>
In-Reply-To: <vP9hdyF4fL.A.WIF.xpzoJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
> Subject		: [Suspend regression][DRM, RADEON]
> Submitter	: etienne <etienne.basset@numericable.fr>
> Date		: 2009-01-28 22:00 (27 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
> 		  http://lkml.org/lkml/2009/2/8/203
> Patch		: http://lkml.org/lkml/2009/2/15/28
> 
> 
> 
hello,

no it's gone, I see Dave sent a modified version of my patch (thanks!)
you can close the bug as far as i m concerned

regards
Etienne
