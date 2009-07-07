Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZGGUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZGGUfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZGGUfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:35:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbZGGUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:35:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #13659] iwlagn (4965): no wireless due to RFKILL problem
Date: Tue, 7 Jul 2009 22:36:00 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.0GF.k0oUKB@chimera> <200907072128.14131.elendil@planet.nl>
In-Reply-To: <200907072128.14131.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072236.01426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Frans Pop wrote:
> On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me
> > know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13659
> > Subject	: iwlagn (4965): no wireless due to RFKILL problem
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2009-06-26 13:36 (11 days old)
> > References	: http://lkml.org/lkml/2009/6/26/127
> > Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> > Patch		: http://lkml.org/lkml/2009/6/27/35
> 
> Should remain listed. Patch is available but not yet upstream.

Thanks for the update.

Best,
Rafael
