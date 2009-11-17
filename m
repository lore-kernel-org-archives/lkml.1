Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZKQLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZKQLpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZKQLp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:45:28 -0500
Received: from lucidpixels.com ([75.144.35.66]:51969 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZKQLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:45:26 -0500
Date: Tue, 17 Nov 2009 06:45:31 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0911170643430.25285@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan>  <1258069232.14894.9.camel@localhost.localdomain>  <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> 
 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>  <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>  <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>  <1258137165.21141.20.camel@localhost.localdomain> 
 <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan> <1258161139.21141.29.camel@localhost.localdomain> <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Nov 2009, Justin Piszcz wrote:

>
>
> On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
>
>> On Fri, 2009-11-13 at 10:43 -0800, Justin Piszcz wrote:
>>> 
>>> On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
>>> 
>>>> On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
>>>>> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
>>>>>> Yes. Yes. This is a hardware errata. I have a patch to workaround this 
>>>>>> and
>>>>>> waiting on the errata description to get published..

1. Do we have an ETA of when this will get published?
2. Is there a patch available for testing?

Another issue, have you tried rebooting any Linux kernel ~2.6.30+ on the
DP55KG?  It hangs at reboot unless you specify reboot=a with various
distributions/live CDs.

Justin.

