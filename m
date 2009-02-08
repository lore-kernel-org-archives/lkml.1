Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZBHWMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZBHWMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZBHWMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:12:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZBHWMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:12:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
Date: Sun, 8 Feb 2009 23:11:59 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Soeren Sonnenburg <kernel@nn7.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.HiF.r20jJB@chimera> <498F5785.3000009@numericable.fr>
In-Reply-To: <498F5785.3000009@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082312.00684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, etienne wrote:
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
> > Date		: 2009-01-28 22:00 (12 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> > References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> > 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
> >
> >
> >   
> hello,
> yes it's still present in -rc4
> But I noticed that when I switch off KDE4.2 desktop effects, suspend to 
> ram is 100% reliable with 2.6.29-rc4
> With 2.6.28, STR is 100% reliable with or without desktop effects

Thanks for the update.

Rafael
