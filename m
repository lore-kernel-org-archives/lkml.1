Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXAWBEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXAWBEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXAWBEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:04:52 -0500
Received: from khc.piap.pl ([195.187.100.11]:53327 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXAWBEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:04:51 -0500
To: Andreas Schwab <schwab@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Heikki Orsila <shdl@zakalwe.fi>,
       Bodo Eggert <7eggert@gmx.de>, Tony Foiani <tkil@scrye.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org, David Schwartz <davids@webmaster.com>
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
References: <7FsPf-51s-9@gated-at.bofh.it> <7FxlV-3sb-1@gated-at.bofh.it>
	<7FyUF-5XD-21@gated-at.bofh.it> <E1H8a7s-0000at-Jx@be1.lrz>
	<20070121150618.GA11613@zakalwe.fi>
	<Pine.LNX.4.61.0701212223340.29213@yvahk01.tjqt.qr>
	<m38xfvrfhm.fsf@maximus.localdomain> <jemz4bmj5z.fsf@sykes.suse.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Jan 2007 02:04:49 +0100
In-Reply-To: <jemz4bmj5z.fsf@sykes.suse.de> (Andreas Schwab's message of "Mon, 22 Jan 2007 11:48:24 +0100")
Message-ID: <m31wlmtuxa.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@suse.de> writes:

> But other than the sector size there is no natural power of 2 connected to
> disk size.  A disk can have any odd number of sectors.

But the manufacturers don't count in sectors.

It should be consistent, though. "How many GB of disk space do you
need to store 2 GB of USB flash, and how many to store 2 GB RAM image"?
:-)
-- 
Krzysztof Halasa
