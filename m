Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHSUJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHSUJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHSUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:08:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:59881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbYHSUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:08:54 -0400
Date: Tue, 19 Aug 2008 12:44:29 -0700
From: Greg KH <gregkh@suse.de>
To: Justin Madru <jdm64@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: Backport hr-tick fix into .25/.26
Message-ID: <20080819194428.GA9997@suse.de>
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu> <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu> <1219138380.10800.376.camel@twins> <20080819182222.GA25576@suse.de> <48AB1F49.6040207@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB1F49.6040207@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:30:17PM -0700, Justin Madru wrote:
> Greg KH wrote:
>> On Tue, Aug 19, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
>>   
>>> That's just flipping sched_feat(HRTICK) to 0 by default.
>>>     
>>
>> That sounds reasonable, I'll take a patch for that for -stable :)
>>
>> thanks,
>>
>> greg k-h
>>
>>   
> Thanks Greg :)
>
> Will the patch make it into 2.6.26.3 and 2.6.25.16, or will it be in the 
> next point releases (2.6.26.4 and 2.6.25.17)?

As no one has sent me any patch to do this, it will be very hard to get
into the release that is happening tomorrow.  It will have to be one
after that.

thanks,

greg k-h
