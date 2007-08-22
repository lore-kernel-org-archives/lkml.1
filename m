Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbXHVVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbXHVVuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbXHVVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:50:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54671 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763508AbXHVVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:50:40 -0400
Message-ID: <46CCAE7A.7000206@vmware.com>
Date: Wed, 22 Aug 2007 14:45:30 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <20070822102217.GE2642@bingen.suse.de> <46CC68D9.5060200@vmware.com> <20070822175918.GB8058@bingen.suse.de> <46CC6D63.2010204@vmware.com> <20070822194632.GD8058@bingen.suse.de> <46CC9FF2.3040406@vmware.com> <20070822220451.GJ8058@bingen.suse.de>
In-Reply-To: <20070822220451.GJ8058@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>
>> We might benefit from it, but would the 
>> BusLogic driver?  It sets a nasty precedent for maintenance as different 
>> hypervisors and emulators hack up different drivers for their own 
>> performance.
>>     
>
> I still think it's preferable to change some drivers than everybody.
>
> AFAIK BusLogic as real hardware is pretty much dead anyways,
> so you're probably the only primary user of it anyways.
> Go wild on it!
>   

It is looking juicy.  Maybe another day.

Zach
