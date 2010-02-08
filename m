Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0BHKJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:09:05 -0500
Received: from chipmunk.wormnet.eu ([195.195.131.226]:40565 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0BHKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:09:03 -0500
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 05:09:03 EST
Date: Mon, 8 Feb 2010 09:59:43 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: Thomas Backlund <tmb@mandriva.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14482] kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Message-ID: <20100208095943.GJ14551@chipmunk>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.85G.9HiZLB@chimera> <4B66F79E.1040606@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B66F79E.1040606@mandriva.org>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Thomas Backlund <tmb@mandriva.org> [2010-02-01 17:47:42+0200]:
>
> 01.02.2010 02:43, Rafael J. Wysocki skrev:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.31 and 2.6.32.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
>> Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
>> Submitter	: Alexander Clouter<alex@digriz.org.uk>
>> Date		: 2009-10-23 10:30 (101 days old)
>> References	: http://lkml.org/lkml/2009/10/23/50
>>
>
> Afaik this is the same issue as the one referenced here:
>
> http://lkml.org/lkml/2010/1/28/292
>
> The patch in the above thread should fix the issue.
>
I'm getting my hands on some not-in-production-state equipment to test 
this with, so bear with me :)

Cheers

-- 
Alexander Clouter
.sigmonster says: Dealer prices may vary.
