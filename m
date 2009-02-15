Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZBOOVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZBOOVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZBOOVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:21:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46801 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbZBOOVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:21:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
Date: Sun, 15 Feb 2009 15:20:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <535841.27007.qm@web53303.mail.re2.yahoo.com>
In-Reply-To: <535841.27007.qm@web53303.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151520.51874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Alberto Gonzalez wrote:
> --- On Sat, 2/14/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > The following bug entry is on the current list of known
> > regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it
> > still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12337
> > Subject		: ~100 extra wakeups reported by powertop
> > Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
> > Date		: 2008-12-31 12:25 (46 days old)
> 
> Yes, still present in latest stable 2.6.28.5
> 
> I updated the report to say that this happened on my 5 year old Pentium 4, but now I got a new Dell desktop (Intel G45 based) and the exact same problem happens, so I can't be the only one seeing it. In the bugzilla Eric Anholt said that it could be related to vblank and that jbarnes had look into a similar issue before, so maybe he has some clue.

Thanks a lot for the update.

Rafael
