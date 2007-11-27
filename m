Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXK0P3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXK0P3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXK0P3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:29:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXK0P3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:29:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Tue, 27 Nov 2007 16:46:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com
References: <20071112064706.GA23595@dose.home.local> <200711262307.56742.rjw@sisk.pl> <20071127132000.GA31893@dose.home.local>
In-Reply-To: <20071127132000.GA31893@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271646.54331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Tino Keitel wrote:
> On Mon, Nov 26, 2007 at 23:07:56 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > On 2.6.23.1 you can test the freezer alone by doing
> > 
> > # echo testproc > /sys/power/disk
> > # echo disk > /sys/power/state
> 
> This is suspend to RAM, not to disk.

I know. :-)

Nevertheless, this is how you can test the tasks freezer _without_ actually
doing a suspend of any kind.

Greetings,
Rafael
