Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZHZACY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZHZACY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZHZACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:02:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZHZACX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:02:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: [Bug #14031] dvb_usb_af9015: Oops on hotplugging
Date: Wed, 26 Aug 2009 02:03:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.RvG.1sGlKB@chimera> <200908260157.48560.s.L-H@gmx.de>
In-Reply-To: <200908260157.48560.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908260203.16548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Wednesday 26 August 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14031
> > Subject		: dvb_usb_af9015: Oops on hotplugging
> > Submitter	: Stefan Lippers-Hollmann <s.L-H@gmx.de>
> > Date		: 2009-08-05 20:32 (21 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124949716608828&w=4
> 
> This issue does not exist in 2.6.31-rc7(-git2) anymore. 
> 
> Unfortunately I've been away from my system and with limited testing 
> abilities recently, so I can't pinpoint the actual patch that fixed this 
> (it was not in the first DVB pull request following that report, but maybe 
> in the second or third), but it does work very well again. Thank you.

Thanks, bug closed.

Rafael
