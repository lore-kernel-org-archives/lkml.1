Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZCOBcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZCOBcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZCOBcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:32:08 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:40854 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbZCOBcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:32:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ZB3qzFpVa2shM64nbUKjXv7R7whS+Yad8FVDPyuPjdsxPfBPgXvyuK4NmbW9CLUB;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <49BC5A90.7070004@earthlink.net>
Date: Sat, 14 Mar 2009 21:32:00 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Ralf Nyren <ralf@nyren.net>, linux-kernel@vger.kernel.org,
       klloyd@sierrawireless.com, rfiler@sierrawireless.com
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com>
In-Reply-To: <20090314203256.GA7487@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec790eb7c6ea9408fff76ef6ef35ca631ce2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Mar 14, 2009 at 08:34:40PM +0100, Ralf Nyren wrote:
>> Hi,
>>
>> I choose to only test download speeds for now but upload will also be of
>> interest later on.
>>
>> I had actually tried to change the N_IN_URB/N_OUT_URB before sending of the
>> report but now I've been testing with both 8 and 128 but the speed remains the
>> same. Download speed max 1.0Mbit/s in Linux while the Windows driver could get
>> an average of 2.5Mbit/s at my current location (different location than during
>> the last test).
>>
>> I have also tried the new 1.6.0 driver as kindly supplied by Sierra but the
>> speed remained the same 1.0Mbit/s with the new driver as well...
>>
>> Anything else you think I could try?
> 
> Then this is not an issue on the kernel side, you might look higher up.
> I have had reports of people incorrectly calculating network speeds
> compared to Windows due to other tools running at the time, or
> misconfigured networks.
> 
> As for how to look into this, sorry, I really don't know.
> 
> good luck,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
Yes, it would be interesting to know how you determined the download speed?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


