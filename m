Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZHZU7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZHZU7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZHZU7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:59:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZHZU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:59:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
Date: Wed, 26 Aug 2009 23:00:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.YH.TtGlKB@chimera> <b637ec0b0908252339u20b7b2c6od3601697cb7aee43@mail.gmail.com>
In-Reply-To: <b637ec0b0908252339u20b7b2c6od3601697cb7aee43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262300.40402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Fabio Comolli wrote:
> Still present as of -rc6-git7 (didn't try -rc7)

Thanks for the update.

Rafael


> On Tue, Aug 25, 2009 at 10:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> > Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> > Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> > Date            : 2009-08-06 20:15 (20 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
