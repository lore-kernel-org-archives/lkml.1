Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYI3CZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYI3CZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYI3CZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:25:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYI3CZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:25:28 -0400
Message-ID: <48E18D21.8040305@zytor.com>
Date: Mon, 29 Sep 2008 19:21:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org> <1222733523.30247.91.camel@alok-dev1> <48E17363.7060103@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15726E51D@orsmsx505.amr.corp.intel.com> <48E17999.8080403@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15726E52E@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15726E52E@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> On 9/29/2008 5:58:01 PM, H. Peter Anvin wrote:
>> Nakajima, Jun wrote:
>>>> We don't have a quorum to create a consensus, since we only have a
>>>> subset of the relevant parties present.
>>> Who else do we need here?
>>>
>> At least Parallels and Virtual PC/Virtual Server.
>>
>>         -hpa
> 
> That should be doable. Although I'm not sure if their engineers want to discuss in public, we can come back with their ack/nak.
> 

OK, if so we should write up a formal proposal.

	-hpa
