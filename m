Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787Ab0ALVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0ALVLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 16:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432Ab0ALVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 16:11:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0ALVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 16:11:09 -0500
Message-ID: <4B4CE35D.4040801@zytor.com>
Date: Tue, 12 Jan 2010 13:02:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
References: <20100109101038.GA17555@in.ibm.com>	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>	 <20100110023015.GA2253@in.ibm.com>	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>	 <20100110102638.GA7838@elte.hu>	 <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>	 <1263246829.2859.537.camel@sbs-t61.sc.intel.com>	 <86802c441001121110u2f3dcfbpafb0d9c4bb6a4e4d@mail.gmail.com> <1263327630.2854.448.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263327630.2854.448.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 12:20 PM, Suresh Siddha wrote:
> On Tue, 2010-01-12 at 11:10 -0800, Yinghai Lu wrote:
>> if the system can not use logical flat.
>>
>> should have some bit set in FADT...
> 
> Yinghai, Sorry. I am not sure what you are referring to here. I have
> mentioned about FADT in another thread, so not sure what you mean by
> this here.
> 
> Are you referring that bios for the IBM system can use this to fix their
> problem? Once we understand what the problem is with IBM platform, then
> we can propose a solution (using FADT perhaps) that is acceptable to
> everyone.
> 

Does the IBM platform set this bit in FADT?

	-hpa
