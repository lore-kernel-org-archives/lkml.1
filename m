Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXAaNGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXAaNGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXAaNGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:06:48 -0500
Received: from mx.laposte.net ([81.255.54.11]:48436 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235AbXAaNGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:06:48 -0500
Message-ID: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
Date: Wed, 31 Jan 2007 14:06:32 +0100 (CET)
Subject: Re: Free Linux Driver Development!
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-3.fc6
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd really love if the same offer was extended to GPL out-of-tree driver
trees.

There are many out-of-tree drivers (ivtv, lirc, various webcam drivers,
enhanced USB keyboard handlers...) with merging not planified or taking
ages.

The associated hardware is useful enough someone wrote a driver.
There is "documentation" in the form of a working driver.
Sometimes there are already many FLOSS apps writen that depend on them.

Yet they languish out-of-tree, effectively sterilizing alternative efforts
just because people know they exist. Someone wrote an howto on how to plug
them in an ancient kernel, and that's good enough to remove a lot of the
merging incentive.

The common wisdom seems to be their authors will hammer LKML hard enough
the driver will eventually be merged. But these authors:
- get set in their ways like any human being
- usually put new features first and merging last
- may have decided merging was too much work
- may be struggling to do it alone
- may have asked LKML about merging once, got ignored/refused (for good,
bad, or obsolete reasons), and decided to spend their time on more
constructive work

So there are many reasons why merging will not happen as things stand.

These drivers are in many ways every bit as harmful as closed binary blobs
(making users miserable, killing alternatives, being a major reason old
kernel binaries get used long after security problems were identified and
fixed, etc). Merging/reworking them is easier than starting from
incomplete NDAed documentation. If (as this offer implies) there are good
driver authors waiting to do more drivering, why aren't those a priority?

As a side effect, cleaning up our own GPL community mess would help
convince hardware manufacturers working within the main kernel is the
right workable solution.

Regards,

-- 
Nicolas Mailhot

