Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXHAKKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXHAKKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbXHAKJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:09:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:52460 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbXHAKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:cc:content-type:mime-version:references:content-transfer-encoding:message-id:in-reply-to:user-agent;
        b=P1KuMGULbEeCX5vI7fWTe/VhRQGGo97zi26b1p5TZ0MsJRhkl7Pb9Xl3jenUicbUBJuMBVWLKkRYnIr2GNe+BQZdszgO/nYzdRAYUWdRZt5spHtD1Iv8Or5yIXUM/tP9q1/XS5kUO/a1/cZiSwjeW0jccbarXiKcuJ1Vqa2a5cU=
Date: Wed, 01 Aug 2007 12:09:33 +0200
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Reboot hang FIXED
From: kriko <kristjan.ugrin@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site> <46AFAF4E.1000605@gmail.com> <op.twcrsx1yatcbto@linux.site> <46B038B5.2030702@gmail.com> <op.twdgw4xiatcbto@linux.site> <46B04896.5020606@gmail.com> <op.twdjn41aatcbto@linux.site> <46B059EB.7060003@gmail.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.twdk57kpatcbto@linux.site>
In-Reply-To: <46B059EB.7060003@gmail.com>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 12:01:15 +0200, Rene Herman <rene.herman@gmail.com>  
wrote:

> On 08/01/2007 11:37 AM, kriko wrote:
>
>>>>  I just want to add that my DVD drive is not detected when using new  
>>>> driver. So back to old one....
>>>
>>> You shouldn't have dropped Alan from CC then... pata_amd, right?
>>>
>>> Rene.
>>  Sorry, yes its pata_amd.
>>  IBM drive is on Primary master (detected as /dev/sdc)
>> DVD-ROM is on Secondary master (not detected)
>
> It's probably a timing issue (and might be related to why the old driver  
> makes the BIOS hang at reboot) but pata_amd should I believe be one of  
> the best tested pata drivers. Using it myself as well, on amd756. I  
> haven't observed any problems with (a few) various CD/DVD drives  
> attached and am not actually sure how to go about debugging the thing --  
> over to Alan.
>
> The DVD-ROM is jumpered for master? Or for cable-select and using the  
> master cable-slot? Using an 80-ribbon cable for it?

It is jumpered as master and connected with first cable-slot.
Cable itself? I don't know, it was supplied with motherboard, though it  
has one pin disabled in middle of connector.


-- 
kriko
