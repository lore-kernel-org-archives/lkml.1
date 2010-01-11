Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0AKTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0AKTwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010Ab0AKTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:52:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0AKTwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:52:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
Date: Mon, 11 Jan 2010 20:52:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.DAC.zglSLB@chimera> <4B4AB589.7080004@xenontk.org>
In-Reply-To: <4B4AB589.7080004@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112052.57339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, David John wrote:
> On 01/11/2010 04:26 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
> > Subject		: i915: Commit 0e442c60 causes flickering
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2009-12-09 17:26 (33 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> > References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> > 
> > 
> > 
> 
> Still present in 2.6.33-rc3.

Thanks for the update.

Rafael
