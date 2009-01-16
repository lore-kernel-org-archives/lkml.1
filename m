Return-Path: <linux-kernel-owner+w=401wt.eu-S934752AbZAPRS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbZAPRS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbZAPRSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:18:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:40039 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760093AbZAPRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QTuuOq7s9PBUeuCr7aPFXbWuJF5NFbv3kC3IyNdBh23kSkRX2MCTIjG3lrIrlz0H/M
         PaaA5kyg2/IrDx45NXTvyqj5xFpCq+IBmJqaHrlP38ftUQ1o0GsaMS0tI/71mmxw7qmV
         1utXClgEJsSkUSyD7forsT8Z0kQENSR4E5Zxs=
Message-ID: <4970C16E.6030107@gmail.com>
Date: Fri, 16 Jan 2009 09:18:38 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
References: <496D759A.7010401@gmail.com> <200901151752.06622.paul.moore@hp.com> <dd18b0c30901151644q4578f7d6k3023cad6f05325dd@mail.gmail.com> <200901161109.27222.paul.moore@hp.com>
In-Reply-To: <200901161109.27222.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Thursday 15 January 2009 7:44:15 pm Justin Mattock wrote:
>   
>> On Thu, Jan 15, 2009 at 2:52 PM, Paul Moore <paul.moore@hp.com> wrote:
>>     
>>> Well, it is possible that /bin/sh points to a non-bash shell but
>>> maybe not (I'm pretty sure the make command executes the scripts
>>> with /bin/sh).  Either way, I checked in the fix to the SVN tree
>>> earlier today so newer releases will have the fix; if needed I can
>>> release a 0.19.1 or similar but I want to wait and see how
>>> widespread the problem is ...
>>>
>>> --
>>> paul moore
>>> linux @ hp
>>>       
>> Cool, If I see anybody
>> struggling, I point them to the
>> fix you posted.
>>     
>
> Great.  Also let me know, if this looks like it will be widespread 
> problem I'll make a new release; I'd hate for people to have to patch 
> the Makefile to get it to build ...
>
>   
no problem.
>> I also might be missing something, i.g.
>> one of the boxes that gave this error I built
>> with debootstrap, but then the other that gave this as well
>> was built with nubuntu which seems more complete
>> than debootstrap.
>> but then maybe both are missing a package.
>> (or it's a debian thing)
>>     
>
> It could also be my rather poor understanding of bash and makefiles :)  
> If anyone out there wants to take a look and offer an explanation or a 
> better patch I'm more than happy to accept it.
>
>   
here as well.

regards;

Justin P. Mattock
