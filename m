Return-Path: <linux-kernel-owner+w=401wt.eu-S1765110AbXFST3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765110AbXFST3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764641AbXFST3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:29:13 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53984
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764645AbXFST3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:29:12 -0400
Date: Tue, 19 Jun 2007 12:28:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Phillip Susi <psusi@cfl.rr.com>
cc: Brendan Conoboy <blc@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <4677F14A.5060909@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0706191225060.25045@asgard.lang.hm>
References: <18034.479.256870.600360@notabene.brown>
 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
 <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
 <Pine.LNX.4.64.0706160037220.7557@asgard <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
 <4677F14A.5060909@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Phillip Susi wrote:

> david@lang.hm wrote:
>>  one channel, 2 OS drives plus the 45 drives in the array.
>
> Huh?  You can only have 16 devices on a scsi bus, counting the host adapter. 
> And I don't think you can even manage that much reliably with the newer 
> higher speed versions, at least not without some very special cables.

6 devices on the bus (2 OS drives, 3 promise drive shelves, controller 
card)

>>  yes I realize that there will be bottlenecks with this, the large capacity
>>  is to handle longer history (it's going to be a 30TB circular buffer being
>>  fed by a pair of OC-12 links)
>
> Building one of those nice packet sniffers for the NSA to install on AT&Ts 
> network eh? ;)

just for going back in time to track hacker actions at a bank.

I'm hopeing that once I figure out the drives the rest of the software 
will basicly boil down to tcpdump with the right options to write to a 
circular buffer of files.

David Lang
