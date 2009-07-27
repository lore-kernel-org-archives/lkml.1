Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZG0VZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZG0VZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZG0VY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:24:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbZG0VY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:24:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Mon, 27 Jul 2009 23:25:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       rui.zhang@intel.com,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.f0H.XYObKB@chimera> <200907270322.47523.elendil@planet.nl>
In-Reply-To: <200907270322.47523.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272325.03259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Frans Pop wrote:
> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> > Subject	: Warning 'Invalid throttling state, reset' gets displayed
> >		  when it should not be
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> > 		  http://bugzilla.kernel.org/attachment.cgi?id=21672
> 
> Rui has acked the patches [1], but AFAIK Len has not yet picked them up.
> 
> [1] http://lkml.org/lkml/2009/7/7/474

No, Len hasn't picked them up, but he's not been responsive recently in
general.

Best,
Rafael
