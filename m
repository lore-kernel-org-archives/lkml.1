Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXAXQ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXAXQ2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXAXQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:28:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:53438 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXAXQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:subject:date:to:x-mailer:from;
        b=E2XAuW+2rwnClTtYZzjxFLDUfR8YqoyFUnO0ZUT/gwGnSx1O7xsp5mrF3gJefkbX7Tpl9X5NabF/jvRss8CL76u/MHdzI6JCAAEGZMCxHlBCZj5FDE2uULZ/eRVBp+CRuUVfWQg8mJeaEMtfL4WEu/GOdddDx+jUZakMOaPqQcA=
In-Reply-To: <964414.64865.qm@web52908.mail.yahoo.com>
References: <964414.64865.qm@web52908.mail.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4238B011-A417-41DE-8998-01BAAA484486@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Subject: Re: 2.6.18-stable release plans?
Date: Wed, 24 Jan 2007 10:28:43 -0600
To: Chris Rankin <rankincj@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2007, at 9:53 AM, Chris Rankin wrote:

>>> But MY kernel is clearly untainted.
>>> So what other explanation is there apart from a kernel bug?
>
>> If it's me you're asking: I don't know (overheating, cosmic  
>> rays, ...)
>
> I suppose what I'm *really* asking is what the basis is for  
> assuming that this *isn't* a kernel
> bug and can therefore be safely ignored, seeing as the oops is  
> real, the hardware is fine and the
> kernel is untainted? That seems to cover the bases from where I'm  
> sitting.
>
> Cheers,
> Chris
>
> P.S. No micro-heatwaves have occurred here, either. Do we all need  
> to install muon detectors in
> our homes before reporting bugs now, so that we can exclude cosmic  
> ray events too?

Well, do you have ECC memory? If not, it is at least possible that  
that the solar flares that occurred last month may have affected your  
system. There were three X-class solar flares in the month of  
December. Even if you have ECC memory, it is still possible to suffer  
data corruption because many BIOSes do not turn on bus parity error  
detection. And are the memories in your disk drive controllers ECC or  
parity protected? I wouldn't bet on it...

All too often, modern PCs are data corruption accidents waiting to  
happen.

-- 
Mark Rustad, MRustad@mac.com


