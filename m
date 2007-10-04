Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXJDCOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXJDCOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXJDCOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:14:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:17459 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbXJDCOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F26U2b680LdrU4gHI0MGhbIC1DV2M7/gXfuYH27eFCgMZZPOIs/aL77wWqPWffohH1bhec/Wnryk8wklapKV4+6/43h9KO0eZl1wrRI4vrgwYKrOHg6E/SrBDRYndmE4Zus1+E7Mr1XJcZy19amwXIJeXLBqTjX4DijdJafmrLk=
Message-ID: <47044C6C.5030905@gmail.com>
Date: Thu, 04 Oct 2007 11:14:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: hgsolari@gmail.com, solari@df.uba.ar
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com> <47014740.5080002@df.uba.ar> <4701EA71.2000609@gmail.com> <470220FE.2090506@gmail.com>
In-Reply-To: <470220FE.2090506@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hernan G Solari wrote:
>>>   netconsole, pritty nice debunging system... but (yes, there is always
>>> a but) it does not get to run.
>>>   the method was well implemented, adding the acpi=off it sends the
>>> information to the receiving machine (I can even see passing a
>>> netconsole probing message in the machine under testing), but without
>>> turning off acpi it does not reach the point of loading and,
>>> consequently, it does not send a byte to the receiving machine.
>>>
>>> Hence, result: empty output.
>>>    
>>>
>> Hmmm.. Are netconsole support and network driver built into the kernel?
>>
> yes, they are

If you can set up a serial console, it would be better.  If not, can you
please take a photo of the crash and post it?

-- 
tejun
