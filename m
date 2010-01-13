Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519Ab0AMVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0AMVxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499Ab0AMVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:53:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0AMVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:53:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: [Bug #14892] intel, KMS, suspend2ram resume, screen black
Date: Wed, 13 Jan 2010 22:53:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A._VC.6glSLB@chimera> <20100113060342.GC3346@gamma.logic.tuwien.ac.at>
In-Reply-To: <20100113060342.GC3346@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001132253.21200.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010, Norbert Preining wrote:
> On So, 10 Jan 2010, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14892
> > Subject		: intel, KMS, suspend2ram resume, screen black
> > Submitter	: Norbert Preining <preining@logic.at>
> > Date		: 2009-11-24 4:35 (48 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125903731125558&w=4
> 
> 2.6.33-rc4 contains the patch posted in bugzilla 14722, so I guess that
> closes it.

I didn't know it was a dup.  Closed now.

Thanks,
Rafael
