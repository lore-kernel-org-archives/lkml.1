Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZBIAju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZBIAju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZBIAjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:39:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZBIAjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:39:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12508] "powerpc/pci: Reserve legacy regions on PCI" broke my G3
Date: Mon, 9 Feb 2009 01:39:05 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.DvG.Y30jJB@chimera> <18831.27907.957902.357829@harpo.it.uu.se>
In-Reply-To: <18831.27907.957902.357829@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902090139.06313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.28.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12508
> >Subject		: "powerpc/pci: Reserve legacy regions on PCI" broke my G3
> >Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> >Date		: 2009-01-17 22:46 (23 days old)
> >First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linu=
> >x-2.6.git;a=3Dcommit;h=3Dc1f343028d35ba4e88cd4a3c44e0d8b8a84264ee
> >References	: http://marc.info/?l=3Dlinux-kernel&m=3D123223247325452&w=3D4
> >Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Fixed in 2.6.29-rc4.

Thanks, closed.

> See <http://marc.info/?l=linux-kernel&m=123394660404763&w=2> (you were CC:d).

Yes, but I wasn't quite sure if that was a mainline commit or a commit from
the Ben's tree.

Thanks,
Rafael
