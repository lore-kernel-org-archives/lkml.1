Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYGMT5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYGMT5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYGMT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:57:25 -0400
Received: from wasp.net.au ([203.190.192.17]:33289 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbYGMT5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:57:24 -0400
Message-ID: <487A5E1C.6080101@wasp.net.au>
Date: Sun, 13 Jul 2008 23:57:16 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11039] 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik> <c6ZRbn0adb.A.dyH.bHleIB@albercik>
In-Reply-To: <c6ZRbn0adb.A.dyH.bHleIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11039
> Subject		: 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
> Submitter	: Brad Campbell <brad@wasp.net.au>
> Date		: 2008-07-03 10:07 (11 days old)
> References	: http://marc.info/?l=linux-netdev&m=121508714430752&w=4

I tested a 2.6.26-rc kernel with forcedeth.c from 2.6.25 and it failed in the same way, so I don't 
think its a regression as such. In any case, with the -rc9 it still fails regularly.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
