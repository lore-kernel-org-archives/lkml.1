Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZJZVAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZJZVAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZJZVAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:00:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZJZVAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:00:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14483] WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x54/0xca()
Date: Mon, 26 Oct 2009 22:01:55 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.hyE.2qe5KB@chimera> <4AE601B1.7050000@gmail.com>
In-Reply-To: <4AE601B1.7050000@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262201.55087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> > Subject		: WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x54/0xca()
> > Submitter	: Justin Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-25 19:58 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
> >
> >
> >
> >    
> yeah this happens on the first go of
> echo mem > /sys/power/state
> for both of my imac's I have here.
> (on the second  try, this message does not appear)

Thanks for the update.

Rafael
