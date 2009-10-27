Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZJ0WLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZJ0WLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZJ0WLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:11:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbZJ0WLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:11:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: [Bug #14484] no video output after suspend
Date: Tue, 27 Oct 2009 23:12:56 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.5tE.0qe5KB@chimera> <4AE7654B.6040401@gmail.com>
In-Reply-To: <4AE7654B.6040401@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910272312.56120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Riccardo Magliocchetti wrote:
> Hello Rafael,
> 
> Rafael J. Wysocki ha scritto:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14484
> > Subject		: no video output after suspend
> > Submitter	: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
> > Date		: 2009-10-25 20:57 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125650430123713&w=4
> > Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Since the bad commit is around 2.6.31-rc9 i think this is a regression 
> from 2.6.30 and not 2.6.31, it's me that have reported the issue so 
> late. Then the patch that you added on the first comment is for another 
> issue and not this one.

Thanks, updated.

Rafael
