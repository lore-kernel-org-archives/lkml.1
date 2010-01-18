Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711Ab0ARQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0ARQYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687Ab0ARQYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:24:44 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:64717 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab0ARQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:24:43 -0500
Date: Mon, 18 Jan 2010 16:13:51 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux driver project <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rt{2860,2870}sta: Use request_firmware() to load firmware
Message-ID: <50E10D0F0C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1263785156.8876.130.camel@localhost>
References: <1263785156.8876.130.camel@localhost>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman 
 <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Linux driver 
 project <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>, 
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.61.0.3112 (Qt/4.5.3) (Linux-x86_64)
X-NuLabour-Date: Mon, 9180 Dec 1984 16:13:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Ben Hutchings may or may not have written...

> When originally introduced into staging, these drivers had custom
> firmware-loading code which checked a version number and CRC at the end of
> each blob.  This reintroduces those checks, using crc-ccitt instead of
> custom code.

> The removed firmware will be added to the linux-firmware.git repository.

> Based on work by Darren Salt <linux@youmustbejoking.demon.co.uk>.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + http://wiki.debian.org/DebianEeePC/

Pentium: Produces Erroneous Numbers Thru' Inadequate Understanding of Maths.
