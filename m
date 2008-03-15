Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYCOXtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYCOXtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYCOXt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:49:26 -0400
Received: from quechua.inka.de ([193.197.184.2]:58168 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYCOXtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:49:25 -0400
X-Greylist: delayed 1828 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 19:49:25 EDT
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <200803151417.13899.phillips@phunq.net>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JafeR-0007m1-00@calista.eckenfels.net>
Date: Sun, 16 Mar 2008 00:18:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <200803151417.13899.phillips@phunq.net> you wrote:
>> RAID controllers do not have half a terabyte of RAM.
> 
> And?  Either you have battery backed ram with critical data in it or
> you do not.  Exactly how much makes little difference to the question.

Besides, some SAN Storage Devices do have that amount of Ram. However it is
better protected as in your typical PC. With Mirroring, it can be removed
(including the battery packs) - and there is a procedure to actually replay
the buffers once the new devices are in place.

But thats not an argument against or in favor of Ramback, its just two
different things. You would be suprised how many databases run on write back
mode disks without fdsync() any nobody cares :)

Greetings
Bernd
