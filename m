Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXAWBwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXAWBwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbXAWBwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:52:53 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:54644 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXAWBww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:52:52 -0500
Date: Tue, 23 Jan 2007 02:45:38 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Andreas Schwab <schwab@suse.de>, Heikki Orsila <shdl@zakalwe.fi>,
       Bodo Eggert <7eggert@gmx.de>, Tony Foiani <tkil@scrye.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org, David Schwartz <davids@webmaster.com>
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
In-Reply-To: <m31wlmtuxa.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.61.0701230243590.317@yvahk01.tjqt.qr>
References: <7FsPf-51s-9@gated-at.bofh.it> <7FxlV-3sb-1@gated-at.bofh.it>
 <7FyUF-5XD-21@gated-at.bofh.it> <E1H8a7s-0000at-Jx@be1.lrz>
 <20070121150618.GA11613@zakalwe.fi> <Pine.LNX.4.61.0701212223340.29213@yvahk01.tjqt.qr>
 <m38xfvrfhm.fsf@maximus.localdomain> <jemz4bmj5z.fsf@sykes.suse.de>
 <m31wlmtuxa.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23 2007 02:04, Krzysztof Halasa wrote:
>Andreas Schwab <schwab@suse.de> writes:
>
>> But other than the sector size there is no natural power of 2 connected to
>> disk size.  A disk can have any odd number of sectors.
>
>But the manufacturers don't count in sectors.
>
>It should be consistent, though. "How many GB of disk space do you
>need to store 2 GB of USB flash, and how many to store 2 GB RAM image"?

Here's the marketing gap a company could jump in:
  "first to count in real GB"


	-`J'
-- 
