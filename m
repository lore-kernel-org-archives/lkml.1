Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYGPIpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYGPIpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYGPIoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:44:54 -0400
Received: from smtp.movial.fi ([62.236.91.34]:58170 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYGPIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:44:53 -0400
Message-ID: <487DB503.10105@movial.fi>
Date: Wed, 16 Jul 2008 11:44:51 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 part 2] [MIPS] make the pcibios_max_latency	variable
 static
References: <1216141052-28005-2-git-send-email-dmitri.vorobiev@movial.fi> <1216195309-13069-1-git-send-email-dmitri.vorobiev@movial.fi> <20080716084310.GA22957@linux-mips.org>
In-Reply-To: <20080716084310.GA22957@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> On Wed, Jul 16, 2008 at 11:01:49AM +0300, Dmitri Vorobiev wrote:
> 
>> Along with making the pcibios_max_latency variable static,
>> its declaration needs to be removed from the header file.
>>
>> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
>> ---
>>
>> Hi Ralf,
>>
>> Forgot about this one yesterday, sorry.
> 
> No big deal, lmo's internet connection was down for part of the afternoon
> so I wasn't doing as much patch stuff as I was hoping to ...
> 
> I folded part 2 into part 1 of your patch and applied the result.

Thank you, Ralf.

Regards,
Dmitri

> 
> Thanks,
> 
>   Ralf
> 

