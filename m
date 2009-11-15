Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZKOSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZKOSKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZKOSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:10:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43834 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZKOSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e0N46KYzcpYWKNv/aexLr2dZ8HP7FWLFQuPPdKmbjoY9xfVBajsU6gQhm0idRanerC
         VYA2AHCmMSgWkRPNMXAKh5xzIFpxSOVKCErcABvSgLJLojmLXQ2/aSMhb+Z7dhDqunzH
         EK33370unQNIDGRHKoiPAISHHOdZfiRPldl+g=
Message-ID: <4B004413.5090903@gmail.com>
Date: Sun, 15 Nov 2009 21:10:27 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>	 <1252936556.28368.215.camel@desktop>	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>	 <1252940549.28368.255.camel@desktop>	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>	 <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>	 <1258305351.6428.8.camel@desktop>	 <94a0d4530911150927l3224e815ha6ff17aab6f19251@mail.gmail.com>	 <1258306352.6428.10.camel@desktop>  <4B00403E.3090907@gmail.com> <1258307915.6428.14.camel@desktop>
In-Reply-To: <1258307915.6428.14.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Sun, 2009-11-15 at 20:54 +0300, Alexey Starikovskiy wrote:
>   
>> You've made changes to automatically generated files, so all the style 
>> changes
>> would be overwritten when next time these files are generated -- all the 
>> files go through
>> Lindent, and almost all your changes were introduced by it. If you 
>> really want to make
>> style changes to ACPICA files, try to play with Lindent, so it produce 
>> what you want.
>> If you have anything beside style patches, please submit them separately
>>
>>     
>
> AFAIK, Lindent can't produce checkpatch clean output. It has to do with
> various short comings in indent. You really need a human to check up on
> it.
>
> Daniel
>
>   
It is not really possible. Lindent is not the last step in the process.


