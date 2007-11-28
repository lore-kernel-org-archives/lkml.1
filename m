Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXK1P2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXK1P2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXK1P2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:28:16 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7201 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXK1P2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:28:14 -0500
Date: Wed, 28 Nov 2007 16:27:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Erkkila <pee@erkkila.org>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
Message-ID: <20071128152700.GO4985@kernel.dk>
References: <20071127150557.GA4365@ics.muni.cz> <200711271637.13036.rjw@sisk.pl> <20071128041155.GB18131@khazad-dum.debian.net> <20071128083153.GL4365@ics.muni.cz> <474D7336.4000102@erkkila.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474D7336.4000102@erkkila.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28 2007, Paul Erkkila wrote:
> Lukas Hejtmanek wrote:
> > On Wed, Nov 28, 2007 at 02:11:55AM -0200, Henrique de Moraes Holschuh wrote:
> >> On Tue, 27 Nov 2007, Rafael J. Wysocki wrote:
> >>>> in recent kernel, I got the following warnings while booting. It's ACPI
> >>>> related. Does anybode care? Lenovo ThinkPad T61 (6465CTO).
> >> Could we know the BIOS version, please?
> > 
> > 7LET56WW (1.26 ) (according to hal, 1.26 is definitely correct, can be seen in
> > BIOS as well)
> > 
> 
> I'm seeing the same thing here, on a similar machine ( 6459CTO ). I
> pulled the source from kernel git last night to test it.
> 
> 
> Bios:
> thinkpad_acpi: ThinkPad BIOS 7LET56WW (1.26 ), EC 7KHT22WW-1.06

I reported the same thing yesterday:

http://lkml.org/lkml/2007/11/27/228

x60 here, latest BIOS.

-- 
Jens Axboe

