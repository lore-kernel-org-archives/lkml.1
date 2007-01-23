Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXAWJXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXAWJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbXAWJXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:23:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:59975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXAWJXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:23:47 -0500
From: Andreas Schwab <schwab@suse.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
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
	<m31wlmtuxa.fsf@maximus.localdomain>
X-Yow: What I need is a MATURE RELATIONSHIP with a FLOPPY DISK...
Date: Tue, 23 Jan 2007 10:23:32 +0100
In-Reply-To: <m31wlmtuxa.fsf@maximus.localdomain> (Krzysztof Halasa's message
	of "Tue, 23 Jan 2007 02:04:49 +0100")
Message-ID: <je8xfujduz.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Andreas Schwab <schwab@suse.de> writes:
>
>> But other than the sector size there is no natural power of 2 connected to
>> disk size.  A disk can have any odd number of sectors.
>
> But the manufacturers don't count in sectors.

The exact number of sectors is often printend on the label.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
