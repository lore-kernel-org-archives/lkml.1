Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXKROhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXKROhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXKROhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:37:24 -0500
Received: from rtr.ca ([76.10.145.34]:2181 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXKROhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:37:24 -0500
Message-ID: <47404E21.8040506@rtr.ca>
Date: Sun, 18 Nov 2007 09:37:21 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kristen.c.accardi@intel.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH] Fix PCIe double initialization bug
References: <4716CB9D.6080503@rtr.ca> <473F86E7.4020003@rtr.ca> <200711181323.52679.rjw@sisk.pl> <47404A21.5010405@rtr.ca>
In-Reply-To: <47404A21.5010405@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Rafael J. Wysocki wrote:
> ..
>> Which kernel is it against?
> ..
>>> This patch is for -mm and for Kristen's queue.  Not for 2.6.24.
> ..
> 
> Patch was generated against 2.6.24-rc2-git4.
..

That is, against 2.6.24-rc2-git4 with the earlier PCIe hotplug patches
also already applied, as they are in -mm and in Kristen's tree.
