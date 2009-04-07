Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbZDGVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbZDGVNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZDGVNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:13:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55888 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZDGVNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:13:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [Bug #12499] Problem with using bluetooth adaper connected to usb port
Date: Tue, 7 Apr 2009 23:13:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.bxC.BJn2JB@chimera> <1239088491.19390.25.camel@violet>
In-Reply-To: <1239088491.19390.25.camel@violet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072313.23603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Marcel Holtmann wrote:
> Hi Rafael,

Hi,

> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12499
> > Subject		: Problem with using bluetooth adaper connected to usb port
> > Submitter	: "Maciej Rutecki" <maciej.rutecki@gmail.com>
> > Date		: 2009-01-13 18:34 (84 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123187185426236&w=4
> 
> I prefer to have this checked against 2.6.30-rc1 once Linus released
> that one. I think that I know the root cause for this one and it is
> actually a hardware/firmware bug. Some Bluetooth dongles expect to have
> the interrupt and bulk URBs available at the same time. Otherwise they
> do pee in their pants.

Works for me. :-)

Thanks,
Rafael
