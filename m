Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZG0WRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZG0WRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZG0WRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:17:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZG0WRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:17:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #13659] iwlagn (4965): no wireless due to RFKILL problem
Date: Tue, 28 Jul 2009 00:17:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.2_E.TIObKB@chimera> <200907270123.31384.elendil@planet.nl>
In-Reply-To: <200907270123.31384.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280017.42250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Frans Pop wrote:
> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13659
> > Subject	: iwlagn (4965): no wireless due to RFKILL problem
> 
> Fixed in mainline by: 76d8b64e536362e16e38ee1c279c965ebfe094cc

Thanks, closed.

Best,
Rafael
