Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZHMGpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZHMGpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZHMGpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:45:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZHMGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:45:43 -0400
Date: Thu, 13 Aug 2009 08:45:43 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: state of the fastboot activities?
Message-ID: <20090813064543.GC13320@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
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
X-Uptime: 08:37:17 up 7 days, 17:56,  2 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Can you elaborate on the current state of the fastboot activities? This
tree here:

http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-async-for-30.git;a=summary

came to a stop in march, and the mainline contains the asyncronous init
stuff, but no "fastboot" parameter as described on LWN:

http://lwn.net/Articles/314808/

Thanks,
rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
