Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYAOVsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYAOVsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYAOVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:48:44 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6578 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbYAOVsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:48:43 -0500
X-SBRS: None
X-MesageID: 37867145
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,289,1196658000"; 
   d="scan'208";a="37867145"
Message-ID: <478D29FC.8040404@citrix.com>
Date: Tue, 15 Jan 2008 13:47:40 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com> <20080114154817.GA14000@elte.hu> <478B96A5.76E4.0078.0@novell.com> <478B9606.6020008@citrix.com> <20080115132423.GD7025@elte.hu>
In-Reply-To: <20080115132423.GD7025@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com> wrote:
>
>   
>>>> coul dyou try this against x86.git as well? We already unified ldt.c as 
>>>> part of the paravirt patches.
>>>>     
>>>>         
>>> Sure, but it may take me a little while.
>>>       
>> I've got the unified version here. 
>>     
>
> thanks, applied.
>
>   
>> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>>     
>
> please use Signed-off-by when passing through (or modifying) patches.
>   

Will do.  That was left over from trying to apply the original version.

    J
