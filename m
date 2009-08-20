Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHTPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHTPES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZHTPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:04:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbZHTPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:04:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
Date: Thu, 20 Aug 2009 17:05:08 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.Kp._NIjKB@chimera> <b637ec0b0908192354o36e8c99qfff7718f26bdfd7b@mail.gmail.com>
In-Reply-To: <b637ec0b0908192354o36e8c99qfff7718f26bdfd7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201705.08449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Fabio Comolli wrote:
> This bug is still present (also in wireless-testing).

Thanks for the update.

Rafael


> On Wed, Aug 19, 2009 at 10:26 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
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
> > Date            : 2009-08-06 20:15 (14 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
