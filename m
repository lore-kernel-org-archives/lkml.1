Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYC1F4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYC1F4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYC1F4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:56:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:42005 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYC1F4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:56:32 -0400
Date: Thu, 27 Mar 2008 23:01:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mark Lord <lkml@rtr.ca>
cc: David Miller <davem@davemloft.net>, rct@frus.com, jkosina@suse.cz,
       gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       pavel@suse.cz, akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7: Ugh.
In-Reply-To: <47EC7F5D.2010104@rtr.ca>
Message-ID: <alpine.DEB.1.00.0803272259340.14073@asgard.lang.hm>
References: <20080327.201202.163153963.davem@davemloft.net> <20080328044258.7AA98DBA2@gherkin.frus.com> <20080327.215622.103233305.davem@davemloft.net> <47EC7F5D.2010104@rtr.ca>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Mark Lord wrote:

> David Miller wrote:
>> From: rct@frus.com (Bob Tracy)
>> Date: Thu, 27 Mar 2008 23:42:58 -0500 (CDT)
>> 
>>> I don't understand this claim.  On what incredibly fast piece of iron
>>> can you possibly do between 8 and 16 kernel builds (the range I've
>>> encountered when I do the "git bisect" dance), boot each one, and
>>> evaluate the results in so small a period of time?
>> 
>> Builds are just over a minute on my box.  I can do a full
>> kernel build plus reboot cycle in under 2 minutes.
> ...
>
> Well, lucky you.
>
> I have a box almost that quick here, too.
> Except it's not the one with the problem.
>
> My main email/work machine is the one with the problem,
> and the downtime is not affordable -- ie. it costs *me* personally money.

not that it's relavent to the problem that you are troubleshooting (based 
on later messages), but I will point out that there is nothing wrong with 
useing a fast box to compile kernels for slower boxes.

David Lang
