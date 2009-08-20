Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZHTVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZHTVci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZHTVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:32:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465AbZHTVch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:32:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [Bug #13948] ath5k broken after suspend-to-ram
Date: Thu, 20 Aug 2009 23:33:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bob Copeland <me@bobcopeland.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.IT.5NIjKB@chimera> <20090820203240.GB4444@sig21.net>
In-Reply-To: <20090820203240.GB4444@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908202333.32416.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Johannes Stezenbach wrote:
> On Wed, Aug 19, 2009 at 10:26:59PM +0200, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
> > Subject		: ath5k broken after suspend-to-ram
> > Submitter	: Johannes Stezenbach <js@sig21.net>
> > Date		: 2009-08-07 21:51 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
> > Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/38550/
> 
> I cannot test this at the moment, but there have been no
> changes to ath5k since I reported the bug, and the
> patch still applies.  Please keep this listed.

OK, thanks for the update.

Rafael
