Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYIKNGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYIKNGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYIKNFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:05:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51451 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYIKNFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:05:52 -0400
Message-ID: <48C9178A.4040307@bull.net>
Date: Thu, 11 Sep 2008 15:05:14 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m1mykyh2fu.fsf_-_@frodo.ebiederm.org>	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com>	<m1tzf593ny.fsf@frodo.ebiederm.org>	<486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de>	<m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070	<m1zlnu60uc.fsf@frodo.ebiederm.org> <48C912CF.7080000@gmail.com>
In-Reply-To: <48C912CF.7080000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Any progress here? Nothing seems reached lkml...

Have a look at Greg's tree. :)
He started to merge the last patches today.

Benjamin

> 
> Eric W. Biederman napsal(a):
>> Greg KH <gregkh@suse.de> writes:
>>
>>> I'll add it to my tree, and get it some testing in the next cycle of
>>> linux-next until 2.6.27 is out, and then if it's still looking good, go
>>> into .28.
>> Greg.  Where are we at with this?
>>
>> I just looked at your tree and I don't perhaps I'm blind but I don't see
>> this patches, and it looks like you at least refreshed your patches
>> a day or two ago.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
