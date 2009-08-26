Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZHZVKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZHZVKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZHZVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:10:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZHZVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:10:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #14030] Kernel NULL pointer dereference at 0000000000000008, pty-related
Date: Wed, 26 Aug 2009 23:11:06 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.D2G.3sGlKB@chimera> <alpine.LFD.2.01.0908251716050.3218@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908251716050.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262311.06860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Linus Torvalds wrote:
> 
> On Tue, 25 Aug 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14030
> > Subject		: Kernel NULL pointer dereference at 0000000000000008, pty-related
> > Submitter	: Eric W. Biederman <ebiederm@xmission.com>
> > Date		: 2009-08-20 5:46 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125074724623423&w=4
> > Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> > Patch		: http://patchwork.kernel.org/patch/43679/
> 
> This is now committed as 5c58ceff103d8a654f24769bb1baaf84a841b0cc. 

Thanks, closed.

Rafael
