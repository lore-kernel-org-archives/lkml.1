Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYEAQ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYEAQ22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYEAQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:28:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:41635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYEAQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,422,1204531200"; 
   d="scan'208";a="323455069"
Message-ID: <4819EF53.6090808@intel.com>
Date: Thu, 01 May 2008 09:26:59 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: starting a kernel-testers group for newbies
References: <261643149@web.de>
In-Reply-To: <261643149@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2008 16:28:02.0740 (UTC) FILETIME=[53B6BF40:01C8ABA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
>> I'll try to do this:
>> - create some Wiki page
>> - get a mailing list at vger
>> - point newbies to this mailing list
>> - tell people there which kernels to test
>> - figure out and document stuff like how to bisect between -next kernels
>> - help them to do whatever is required for a proper bug report
> 
> good idea :)
> 
> one more:
> reported bugs sometimes get lost in lkml (or elsewhere) and may not get the attention they need.
> 
> maybe there are not enough people who put some steadiness into tracking bugs (i.e. put them in bugzilla and make sure they get tracked/resolved) ?


I would say that this should be one of the main goals - have a team of people who
can consistently be assigned bugs for duplication and verification. Getting newly
opened bugs reproduced can be half the solution (and a great way to learn the
kernel on the side).

often the reporter of the bug never confirms that the bug is fixed - another place
where linux testers can help out...

Auke
