Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800Ab0AXMWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0AXMWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 07:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587Ab0AXMWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 07:22:54 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61718 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0AXMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 07:22:54 -0500
Date: Sun, 24 Jan 2010 13:22:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: George Joseph <George.joseph@fairview5.com>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Status of Andigilog asc7621 driver submitted by George Joseph
 on   2008-05-29
Message-ID: <20100124132245.092835ca@hyperion.delvare>
In-Reply-To: <3f9a31f41001240414x4c706181s64392c79be4c4141@mail.gmail.com>
References: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
	<20100124103019.6c6f23a6@hyperion.delvare>
	<3f9a31f41001240414x4c706181s64392c79be4c4141@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 17:44:11 +0530, Jaswinder Singh Rajput wrote:
> Hello Jean,
> 
> On Sun, Jan 24, 2010 at 3:00 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Sat, 23 Jan 2010 23:22:29 +0530, Jaswinder Singh Rajput wrote:
> >> Andigilog asc7621 driver submitted by George Joseph on 2008-05-29,
> >> This chip is used by various Intel Motherboards.
> >>
> >> Is it still under review and testing :
> >>
> >> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-May/023257.html
> >>
> >> http://www.spinics.net/lists/lm-sensors/msg26915.html
> >>
> >> http://www.spinics.net/lists/lm-sensors/msg26916.html
> >>
> >> http://www.lm-sensors.org/wiki/Devices
> >
> > I've updated the wiki entry to point to the latest version of the
> > driver. I've also included a complete list of known requests so far,
> > which can be used to get in touch with potential testers.
> >
> 
> Thanks for updating the wiki.
> 
> Latest asc7621 driver is giving compilation errors with latest kernel
> git. Do you also also have plans to update the driver so that we can
> use the asc7621 driver.
> 
> I am ready for testing and debugging it.

No, I don't have any plan. I already have too much on my plate, adding
anything would be unreasonable.

The only way I would start working on this is if someone would offer me
one of these motherboards which use the chip in question.

-- 
Jean Delvare
