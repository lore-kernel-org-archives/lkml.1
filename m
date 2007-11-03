Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXKCUiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXKCUiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXKCUiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:38:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbXKCUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:38:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [RFC][PATCH 3/3] PM: Suspend/hibernation debug documentation update (rev. 2)
Date: Sat, 3 Nov 2007 21:54:48 +0100
User-Agent: KMail/1.9.5
Cc: johannes@sipsolutions.net, lenb@kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz
References: <200711032054.40195.rjw@sisk.pl> <200711032058.23358.rjw@sisk.pl> <E1IoPIE-0005qK-9U@faramir.fjphome.nl>
In-Reply-To: <E1IoPIE-0005qK-9U@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711032154.49758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 November 2007 21:08, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> > +core run in a test mode.  There are 5 test modes available:
> > +
> > +freezer - test the freezing of processes
> > +devices - test the freezing of processes and suspending of devices
> > +platform - test the freezing of processes, suspending of devices and platform
> > +           global control methods(*)
> > +processors - test the freezing of processes, suspending of devices, platform
> > +             global control methods(*) and the disabling of nonboot CPUs
> > +core - test the freezing of processes, suspending of devices, platform global
> > +       control methods(*), the disabling of nonboot CPUs and suspending of
> > +       platform/system devices
> 
> I'd suggest to indent this as follows:
> - freezer
>   Test the freezing of processes.
> - devices
>   Test the freezing of processes and suspending of devices.
> - platform
>   Test the freezing of processes, suspending of devices and platform global
>   control methods(*).
> - processors
>   Test the freezing of processes, suspending of devices, platform global
>   control methods(*) and the disabling of nonboot CPUs.
> - core
>   Test the freezing of processes, suspending of devices, platform global
>   control methods(*), the disabling of nonboot CPUs and suspending of
>   platform/system devices.

Yup, this way it looks better.

Thanks,
Rafael
