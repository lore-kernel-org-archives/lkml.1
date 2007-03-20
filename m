Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXCTUAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXCTUAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXCTUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:00:31 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:65218 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXCTUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:00:27 -0400
Date: Tue, 20 Mar 2007 15:59:29 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch 00/31] 2.6.20-stable review
In-reply-to: <20070320155259.GC14889@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-id: <200703201559.29508.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070319213647.GB9261@kroah.com>
 <200703200115.05861.gene.heskett@gmail.com> <20070320155259.GC14889@suse.de>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007, Greg KH wrote:
>On Tue, Mar 20, 2007 at 01:15:02AM -0400, Gene Heskett wrote:
>> In any event, something tickled the monster, and its hungry.  This is
>> a full-stop, show-stopper AFAIAC.
>>
>> I'll cut that patch-2.6.20.4-rc1 in halves, and build 2 more test
>> kernels tomorrow to start a bisect if no one has any better idea
>> before then.
>
>I'd recommend using the quilt tree of patches to do this, it will be
>easier than trying to split the larger patch up into pieces by hand.
>
>thanks,
>
>greg k-h

I don't have quilt installed, and no idea how to use it if it was, Greg.  
Even my git is now pushing a year old.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If I were a grave-digger or even a hangman, there are some people I could
work for with a great deal of enjoyment.
		-- Douglas Jerrold
