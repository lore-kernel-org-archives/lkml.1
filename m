Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYHSTbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYHSTbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYHSTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:30:38 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:57588 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753270AbYHSTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:30:37 -0400
Message-ID: <48AB1F49.6040207@gawab.com>
Date: Tue, 19 Aug 2008 12:30:17 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: Backport hr-tick fix into .25/.26
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu> <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu> <1219138380.10800.376.camel@twins> <20080819182222.GA25576@suse.de>
In-Reply-To: <20080819182222.GA25576@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 19, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
>   
>> That's just flipping sched_feat(HRTICK) to 0 by default.
>>     
>
> That sounds reasonable, I'll take a patch for that for -stable :)
>
> thanks,
>
> greg k-h
>
>   
Thanks Greg :)

Will the patch make it into 2.6.26.3 and 2.6.25.16, or will it be in the 
next point releases (2.6.26.4 and 2.6.25.17)?

Justin Madru
