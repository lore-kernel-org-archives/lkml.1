Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbZDGT7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbZDGT7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbZDGT6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:58:46 -0400
Received: from rtr.ca ([76.10.145.34]:44078 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760313AbZDGT6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:58:45 -0400
Message-ID: <49DBB071.6000105@rtr.ca>
Date: Tue, 07 Apr 2009 15:58:41 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49DB8B54.7050402@garzik.org> <49DB9422.5040702@rtr.ca> <20090407181033.GA2673@gentoox2.trippelsdorf.de>
In-Reply-To: <20090407181033.GA2673@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> On Tue, Apr 07, 2009 at 01:57:54PM -0400, Mark Lord wrote:
>> Are there any commercially available SSDs that have this feature yet?
>> Anyone know which ones?
> 
> OCZ will release a new firmware for their Vertex line in the coming
> days, which will feature ATA TRIM support.
> And since they get their firmware directly from Indilinx, all SSDs
> with this controller will be TRIM ready in the future.
> 
> http://www.ocztechnologyforum.com/forum/showthread.php?t=54373
..

Mmm.. sounds like they really don't understand "standards" there.
All of that nonsense about waiting until their proprietary "trim utility"
is working on Windows-7 before looking at a Linux implementation.

WTF?  So long as they implement the required ATA opcode (correctly),
then it should "just work" fine on Linux.  But that Windows-centred
discussion there really doesn't sound encouraging.

But hey, if they do get their act together, then the Vertex series
are supposedly the second-best consumer SSDs available these days,
after the highly touted/priced Intel ones.  :)

Cheers

