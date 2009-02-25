Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZBYW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZBYW6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbZBYW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:58:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZBYW6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:58:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
Date: Wed, 25 Feb 2009 23:58:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.WIF.xpzoJB@chimera> <49A39A2D.7020007@numericable.fr>
In-Reply-To: <49A39A2D.7020007@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252358.10362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, etienne wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
> > Subject		: [Suspend regression][DRM, RADEON]
> > Submitter	: etienne <etienne.basset@numericable.fr>
> > Date		: 2009-01-28 22:00 (27 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> > References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> > 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
> > 		  http://lkml.org/lkml/2009/2/8/203
> > Patch		: http://lkml.org/lkml/2009/2/15/28
> > 
> > 
> > 
> hello,
> 
> no it's gone, I see Dave sent a modified version of my patch (thanks!)
> you can close the bug as far as i m concerned

Thanks, closed.

Rafael
