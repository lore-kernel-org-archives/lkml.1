Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYFFIwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYFFIwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYFFIv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:51:57 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:34700 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYFFIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:51:56 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4848FAA9.6020808@cam.ac.uk>
Date: Fri, 06 Jun 2008 09:51:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
CC: Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
       Torokhov <dmitry.torokhov@gmail.com>, Burman <burman.yan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, HWMON <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Pavel Machek <pavel@suse.cz>, Yan@ATrpms.net, Dmitry@ATrpms.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost>	<4846EBF5.2030406@tremplin-utc.net>	<20080604225830.1dff64fc@hyperion.delvare>	<20080604230510.GB30475@elf.ucw.cz>	<484728B2.1000209@tremplin-utc.net> <20080605082950.6957f1a2@hyperion.delvare> <4847B415.2080708@cam.ac.uk> <48484DD6.3050706@tremplin-utc.net>
In-Reply-To: <48484DD6.3050706@tremplin-utc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Still, it may take some time to iron out the various kinks in this system
>> and get it fully tested, so may be worth putting stuff elsewhere for now
>> with the intention to move it as and when the more unified stuff has been
>> written.
> Yes, so I'll keep my plan of first submitting the driver with the
> current interface, and latter updating the interface to the new
> subsystem when you have stabilised its interface.
Probably best plan!
> BTW, just by curiosity, is your tree available publicly somewhere?
Not just yet. (doesn't all work as of yet and I need to get at least a couple
of devices working with it be sure I haven't written something too device
specific)

I'll post to the relevant mailing lists when it reaches a more reasonable 
state and the 'arguments' can begin ;)

Jonathan

