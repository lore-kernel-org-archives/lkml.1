Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZBFX4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZBFX4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZBFX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:56:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBFX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:56:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
Date: Sat, 7 Feb 2009 00:55:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>, nbd@openwrt.org
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.uoH.6vYiJB@chimera> <20090206184156.M22909@bobcopeland.com>
In-Reply-To: <20090206184156.M22909@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902070055.25724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Bob Copeland wrote:
> On Wed,  4 Feb 2009 11:23:57 +0100 (CET), Rafael J. Wysocki wrote
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
> > Subject		: ath5k related kernel panic in 2.6.29-rc1
> > Submitter	: Sergey S. Kostyliov <rathamahata@gmail.com>
> > Date		: 2009-01-12 7:38 (24 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
> > Handled-By	: Bob Copeland <me@bobcopeland.com>
> 
> Yes, this should still be listed.  Seems there is corruption of the rate
> indexes but I haven't found it yet.  Felix Fietkau added to CC in case
> he has any thoughts.

Thanks for the update.

Rafael
