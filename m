Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbXHKJiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbXHKJiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXHKJiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:38:05 -0400
Received: from aug.linbit.com ([212.69.162.22]:44193 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755374AbXHKJiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:38:03 -0400
Date: Sat, 11 Aug 2007 11:38:05 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: LKML Kernel <linux-kernel@vger.kernel.org>
Subject: DRBD - what is it, anyways? [compare with e.g. NBD + MD raid]
Message-ID: <20070811093805.GA5185@racke.local>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	LKML Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, I did not have the time to "beautify" our code base further,
so still no patch submission for the in-depth review. looking at my
schedule, this probably has to wait for september at the very least
 :(

meanwhile, please, anyone interessted,
the drbd paper for LinuxConf Eu 2007 is finalized.
http://www.drbd.org/fileadmin/drbd/publications/drbd8.linux-conf.eu.2007.pdf

it does not give too much implementation detail (would be inapropriate
for conference proceedings, imo; some paper commenting on the source
code should follow).

but it does give a good overview about what DRBD actually is,
what exact problems it tries to solve,
and what developments to expect in the near future.

so you can make up your mind about
 "Do we need it?", and
 "Why DRBD? Why not NBD + MD-RAID?"

thanks,

	Lars
