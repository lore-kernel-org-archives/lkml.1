Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886Ab0AMGju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0AMGju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343Ab0AMGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:39:49 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46180 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0AMGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:39:48 -0500
X-Greylist: delayed 2165 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 01:39:48 EST
Date: Wed, 13 Jan 2010 07:03:42 +0100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14892] intel, KMS, suspend2ram resume, screen black
Message-ID: <20100113060342.GC3346@gamma.logic.tuwien.ac.at>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A._VC.6glSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CXIfLt-ygXM.A._VC.6glSLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 10 Jan 2010, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14892
> Subject		: intel, KMS, suspend2ram resume, screen black
> Submitter	: Norbert Preining <preining@logic.at>
> Date		: 2009-11-24 4:35 (48 days old)
> References	: http://marc.info/?l=linux-kernel&m=125903731125558&w=4

2.6.33-rc4 contains the patch posted in bugzilla 14722, so I guess that
closes it.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
RUNCORN (n.)
A peeble (q.v.) which is larger that a belper (q.v.)
			--- Douglas Adams, The Meaning of Liff
