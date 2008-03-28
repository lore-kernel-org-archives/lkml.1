Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYC1FRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYC1FRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYC1FRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:17:23 -0400
Received: from rtr.ca ([76.10.145.34]:1180 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYC1FRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:17:23 -0400
Message-ID: <47EC7F5D.2010104@rtr.ca>
Date: Fri, 28 Mar 2008 01:17:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: rct@frus.com, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327.201202.163153963.davem@davemloft.net>	<20080328044258.7AA98DBA2@gherkin.frus.com> <20080327.215622.103233305.davem@davemloft.net>
In-Reply-To: <20080327.215622.103233305.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: rct@frus.com (Bob Tracy)
> Date: Thu, 27 Mar 2008 23:42:58 -0500 (CDT)
> 
>> I don't understand this claim.  On what incredibly fast piece of iron
>> can you possibly do between 8 and 16 kernel builds (the range I've
>> encountered when I do the "git bisect" dance), boot each one, and
>> evaluate the results in so small a period of time?
> 
> Builds are just over a minute on my box.  I can do a full
> kernel build plus reboot cycle in under 2 minutes.
...

Well, lucky you.

I have a box almost that quick here, too.
Except it's not the one with the problem.

My main email/work machine is the one with the problem,
and the downtime is not affordable -- ie. it costs *me* personally money.

Cheers
