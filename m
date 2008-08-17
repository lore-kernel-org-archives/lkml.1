Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYHQKYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYHQKYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 06:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYHQKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 06:23:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYHQKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 06:23:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #11205] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Date: Sun, 17 Aug 2008 12:27:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.2aH.xczpIB@albercik> <18599.60267.441793.686251@harpo.it.uu.se>
In-Reply-To: <18599.60267.441793.686251@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171227.31963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Mikael Pettersson wrote:
> On Sat, 16 Aug 2008 21:02:46 +0200 (CEST), Rafael J. Wysocki wrote:
> >The following bug entry is on the current list of known regressions
> >from 2.6.26.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11205
> >Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
> >Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> >Date		: 2008-07-30 11:02 (18 days old)
> >References	: http://marc.info/?l=3Dlinux-kernel&m=3D121741584608240&w=3D4
> >Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> >Patch		: http://marc.info/?l=3Dlinux-kernel&m=3D121742199419686&w=3D2
> 
> The fix is now in Linus' tree. Commit 1c5b0eb66d74683e2be5da0c53e33c1f4ca982fd.

Thanks, closed.

Rafael

