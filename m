Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZA3XHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZA3XHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZA3XG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:06:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZA3XG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:06:59 -0500
Date: Sat, 31 Jan 2009 00:06:33 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Steven Rostedt <srostedt@redhat.com>, avorontsov@ru.mvista.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-rt-users@vger.kernel.org, Uwe Kleine-Koenig <ukl@pengutronix.de>
Subject: Re: 2.6.28-rt on PowerPC
Message-ID: <20090130230633.GG32026@pengutronix.de>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233270043.3833.57.camel@localhost.localdomain> <49823A13.50703@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <49823A13.50703@am.sony.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 00:04:46 up 11 days, 12:36,  7 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank,

On Thu, Jan 29, 2009 at 03:21:55PM -0800, Frank Rowand wrote:
> > Thanks! I have not yet had the chance to apply any arch patches yet. I
> > do plan on doing so after getting the code mostly working on x86.
> 
> Your email can at an opportune time for me...  I was starting to try
> 2.6.28-rt on ARM and quickly came to the conclusion that the arch
> patches weren't the focus yet.  But I'm currently side-tracked with
> getting my board to even boot a vanilla 2.6.28 kernel first.  Do
> you expect to get to the arches in the next week or two?  If not,
> I may head down that path for ARM myself.

Uwe has collected some patches for ARM here:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/52108/focus=787937

You might want to try them before starting, in order to avoid duplicate
work.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
