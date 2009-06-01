Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZFAURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZFAURR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZFAURG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:17:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZFAURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:17:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Atterer <richard@2009.atterer.net>
Subject: Re: [Bug #13371] s2disk hangs with e100, kernel 2.6.29 and later
Date: Mon, 1 Jun 2009 22:17:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A.i1F.bVbIKB@chimera> <20090531021912.GA11361@arbonne.lan>
In-Reply-To: <20090531021912.GA11361@arbonne.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012217.33552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, Richard Atterer wrote:
> This bug is still present.
> 
> On Sat, May 30, 2009 at 09:55:39PM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
> > Subject		: s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
> 
> Better: s2disk hangs with e100, kernel 2.6.29 and later
> 
> > Submitter	: Richard Atterer <richard@2009.atterer.net>
> > Date		: 2009-05-16 22:51 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
> > 		  http://lkml.org/lkml/2009/5/25/253
> 
> Latest information: The e100 driver is responsible for the problem. 
> http://lkml.org/lkml/2009/5/25/440
> 
> Maybe handled by: Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
> :)

Thanks for the update. :-)

Best,
Rafael
