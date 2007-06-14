Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXFNVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXFNVJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXFNVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:09:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:32909 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbXFNVJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:09:03 -0400
Message-ID: <4671AE5E.4090602@tmr.com>
Date: Thu, 14 Jun 2007 17:08:46 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: raid5: coding style cleanup / refactor
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>	 <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com> <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
In-Reply-To: <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
>> In other words, it seemed like a good idea at the time, but I am open
>> to suggestions.
>>
>
> I went ahead and added the cleanup patch to the front of the
> git-md-accel.patch series.  A few more whitespace cleanups, but no
> major changes from what I posted earlier.  The new rebased series is
> still passing my tests and Neil's tests in mdadm. 
When you are ready for wider testing, if you have a patch against a 
released kernel it makes testing easy, characteristics are pretty well 
known already.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

