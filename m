Return-Path: <linux-kernel-owner+w=401wt.eu-S940616AbXGSRWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940616AbXGSRWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940532AbXGSRVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:21:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42261 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940526AbXGSRVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:21:41 -0400
Message-ID: <469F9D92.9000708@us.ibm.com>
Date: Thu, 19 Jul 2007 10:21:22 -0700
From: Mingming Caoc <cmm@us.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       Doug Chapman <doug.chapman@hp.com>, Vasily Tarasov <vtaras@openvz.org>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com> <a781481a0707191007q241f5f5bh6c029da56090d8b3@mail.gmail.com>
In-Reply-To: <a781481a0707191007q241f5f5bh6c029da56090d8b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> Subject         : ext4 build warnings
>> References      : http://lkml.org/lkml/2007/7/18/420
>> Last known good : ?
>> Submitter       : Jeff Garzik <jeff@garzik.org>
>> Caused-By       : ?
>> Handled-By      : Mingming Cao <cmm@us.ibm.com>
>> Status          : unknown
> 
> Mingming Cao fixed this:
> 
> http://lkml.org/lkml/2007/7/18/564
> 
> Dunno if it's in latest git

Andrew pushed the patch to Linus last night.

Thanks,

Mingming
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


