Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZBIKZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZBIKZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZBIKZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:25:40 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43151 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZBIKZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:25:39 -0500
Date: Mon, 9 Feb 2009 10:24:36 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <sWhNs83kKPE.A.IDG.z20jJB@chimera>
Message-ID: <Pine.LNX.4.64.0902091023150.14410@blonde.anvils>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.IDG.z20jJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12608
> Subject		: 2.6.29-rc powerpc G5 Xorg legacy_mem regression
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2009-01-21 21:12 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3a54014e2a94bd37b7dee5e76e03f7bc4fab49a
> References	: http://marc.info/?l=linux-kernel&m=123257250431870&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Please still list it for now, but I expect Ben's fix to be in -rc5.

Hugh
