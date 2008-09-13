Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYIMAln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYIMAln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYIMAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:41:30 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:60049 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbYIMAl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:41:29 -0400
Message-ID: <48CB0CDD.9020706@keyaccess.nl>
Date: Sat, 13 Sep 2008 02:44:13 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP PAT issue.
References: <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <48AF1B6A.80408@keyaccess.nl> <48C8259B.7040702@keyaccess.nl> <20080911081702.GA27425@elte.hu> <48C8D731.4000309@keyaccess.nl> <7E82351C108FA840AB1866AC776AEC462CA8E8B7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC462CA8E8B7@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-08 02:26, Pallipadi, Venkatesh wrote:

>>>> Haven't been subcribed to any lists recently and someone was 
>>>> talking about "the other thread" before but just noticed that 
>>>> an-rc6 was cut.
>>>> 
>>>> Please note that the shutdown issue remains unfixed in it (I'm 
>>>> doing my coalescing changes locally).
>>>> 
>>> here's what is pending in tip/x86/pat for v2.6.28:
>>> 
>> Only talking about .27 and just making sure again the issue is 
>> known.
>> 
>> The above mentioned subject for the entry cache one ("fix Xorg 
>> startup/shutdown slowdown with PAT") after all mistakingly says it 
>> does something for shutdown.
>> 
> Can you try the patch here 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html
> 
> That should resolve both reserve and free issues..

Not for .27 though.

Rene.
