Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYA1Unx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYA1Unx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYA1Unl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:43:41 -0500
Received: from rtr.ca ([76.10.145.34]:4938 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbYA1Unk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:43:40 -0500
Message-ID: <479E3E7A.7000308@rtr.ca>
Date: Mon, 28 Jan 2008 15:43:38 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801281156.28844.gene.heskett@gmail.com> <479E1CF4.7060706@rtr.ca> <200801281359.24050.gene.heskett@gmail.com>
In-Reply-To: <200801281359.24050.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Monday 28 January 2008, Mark Lord wrote:
>..
>> Another way is to use the "make_bad_sector" utility that
>> is included in the source tarball for hdparm-7.7, as follows:
>>
>>   make_bad_sector --readback /dev/sda 474507
>>
> Apparently not in the rpm, darnit.
..

That's okay.  It should still be in the SRPM source file.
And it's a tiny download from sourceforge.net:

http://sourceforge.net/search/?type_of_search=soft&type_of_search=soft&words=hdparm

Cheers
