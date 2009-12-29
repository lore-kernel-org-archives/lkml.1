Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZL2WiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZL2WiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZL2WiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:38:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZL2WiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:38:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes the screen flicker
Date: Tue, 29 Dec 2009 23:38:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.2TD.WxhOLB@chimera> <1262120568.3523.4.camel@localhost.localdomain>
In-Reply-To: <1262120568.3523.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292338.33319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Thomas Meyer wrote:
> Am Dienstag, den 29.12.2009, 16:28 +0100 schrieb Rafael J. Wysocki:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
> > Subject		: i915: playing video via XVideo extension makes the screen flicker
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2009-11-23 13:15 (37 days old)
> 
> Need to boot 2.6.32.2 with "nomodeset" option to make the above bug go
> away. Without "nomodeset" option, i.e. the default for intel kms, the
> system behaves very strangley/sluggish under 2.6.32.2.
> 
> So yes, please still list this bug.

OK, thanks for the update.

Rafael
