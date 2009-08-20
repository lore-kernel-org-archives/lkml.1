Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZHTTBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZHTTBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZHTTBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:01:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39053 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZHTTBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:01:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #13634] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22
Date: Thu, 20 Aug 2009 21:02:00 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera> <200908202019.23819.rjw@sisk.pl> <20090820115130.6f824b8a@jbarnes-g45>
In-Reply-To: <20090820115130.6f824b8a@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908202102.00850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Jesse Barnes wrote:
> On Thu, 20 Aug 2009 20:19:23 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday 20 August 2009, Jesse Barnes wrote:
> > > On Wed, 19 Aug 2009 22:40:45 +0200 (CEST)
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > This message has been generated automatically as a part of a
> > > > report of regressions introduced between 2.6.29 and 2.6.30.
> > > > 
> > > > The following bug entry is on the current list of known
> > > > regressions introduced between 2.6.29 and 2.6.30.  Please verify
> > > > if it still should be listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=13634
> > > > Subject		: [drm:drm_wait_vblank] *ERROR* failed to
> > > > acquire vblank counter, -22 Submitter	: Cijoml Cijomlovic
> > > > Cijomlov <cijoml@volny.cz> Date		: 2009-06-27 07:02
> > > > (54 days old)
> > > 
> > > Patches to fix this have been queued.
> > 
> > Thanks for the update.
> > 
> > Can you please give me a pointer to the patch?
> 
> commit 8d3457ec3198a569dd14dc9e3ae8b6163bcaa0b5
> Author: Paul Rolland <rol@as2917.net>
> Date:   Sun Aug 9 12:24:01 2009 +1000
> 
> Already in Linus's tree actually.

Thanks, closed.

Rafael
