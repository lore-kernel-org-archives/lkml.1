Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbXAWNOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbXAWNOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965024AbXAWNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:14:12 -0500
Received: from khc.piap.pl ([195.187.100.11]:58853 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014AbXAWNOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:14:11 -0500
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
	<m31wlmtuxa.fsf@maximus.localdomain> <je8xfujduz.fsf@sykes.suse.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Jan 2007 14:14:09 +0100
In-Reply-To: <je8xfujduz.fsf@sykes.suse.de> (Andreas Schwab's message of "Tue, 23 Jan 2007 10:23:32 +0100")
Message-ID: <m364ax28da.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@suse.de> writes:

> The exact number of sectors is often printend on the label.

Sure, I'd even say "almost always" for recent disks. Still, they
count in GBs, not sectors.

OTOH it would be great if they say "xxx,xxx,xxx 512-byte sectors",
and maybe "approx. X GB".
-- 
Krzysztof Halasa
