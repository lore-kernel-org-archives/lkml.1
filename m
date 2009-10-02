Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZJBG1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZJBG1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZJBG1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:27:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54347 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbZJBG1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:27:38 -0400
Date: Fri, 2 Oct 2009 08:27:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Deepak Saxena <dsaxena@laptop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Bug #14297] console resume broken since ba15ab0e8d
Message-ID: <20091002062740.GG27039@pengutronix.de>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <Q3xT3CnoTGE.A.slG.H4SxKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Q3xT3CnoTGE.A.slG.H4SxKB@chimera>
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
X-Uptime: 08:25:48 up 14 days, 20:41, 41 users,  load average: 0.08, 0.08,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thu, Oct 01, 2009 at 09:38:46PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
> Subject		: console resume broken since ba15ab0e8d
> Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
> Date		: 2009-09-30 15:11 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4

Thanks for reporting this. Yes, the entry is still valid.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
