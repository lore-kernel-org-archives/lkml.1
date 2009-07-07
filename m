Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZGGUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZGGUY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZGGUYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:24:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZGGUYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:24:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>, "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: [Bug #13651] Anyone know what happened with PC speaker in 2.6.30?
Date: Tue, 7 Jul 2009 22:24:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ken Witherow" <ken@krwtech.com>, "Takashi Iwai" <tiwai@suse.de>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.nYG.7_oUKB@chimera> <200907072113.18608.elendil@planet.nl>
In-Reply-To: <200907072113.18608.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072224.37623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Frans Pop wrote:
> On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13651
> > Subject	: Anyone know what happened with PC speaker in 2.6.30?
> > Submitter	: Michael Tokarev <mjt@tls.msk.ru>
> > Date		: 2009-06-15 14:41 (22 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124507695427817&w=4
> 
> Given the last comments from Michael I think this should be closed as "not 
> a bug". The observed behavior is intended.
> See: http://lkml.org/lkml/2009/6/29/232.

Well, I guess the regression here is the apparent lack of documentation, but
now that the problem has been discussed, I guess this is not a problem any
more.

Best,
Rafael
