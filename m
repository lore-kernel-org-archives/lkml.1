Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYDQHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYDQHsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYDQHsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:48:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:18646 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbYDQHsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=o7G/280EFurn2t7kjO3bVQmjGHrKpfY7465cP2c8g0g+fA5tGhygEw+ckNrEeZ3EVV/s0qnt7q3h6NBfQJCChJjXu0LMv+utEPVl72MBcUnrsQ5WwZWjZJiOmeb/XGJwvyuqhEVTm4m9uvVzQvtWVeK5rJP3fzM5xS2uhYRB64M=
Message-ID: <480700B2.5050302@tuffmail.co.uk>
Date: Thu, 17 Apr 2008 08:48:02 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: Self-snapshotting in Linux
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it>	 <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com> <1208393723.6206.1.camel@nigel-laptop>
In-Reply-To: <1208393723.6206.1.camel@nigel-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
>
> On Wed, 2008-04-16 at 03:27 -0700, Alan Jenkins wrote:
>   
>> I guess there is the hardware / drivers issue.  I would like to claim
>> I've found hibernation to be reliable but unfortunately that's not
>> 100% true.  As you say, that's inherent to snapshotting on
>> unvirtualised hardware - calling it snapshotting instead of
>> hibernation wouldn't change anything.
>>     
>
> On a particular set of hardware, it should be possible to make it 100%
> reliable. If you've found bugs, please report them. We can only fix
> issues if we know they exist.
>   
Thanks!

I already replied to Pavels similar comment - I had posted on Bugzilla.  
I guess it missed the right people because it started off in the wrong 
category.  (The first symptom I reported was my 2.13Ghz cpu running at 
1Ghz after a sucessful hibernation cycle).  At Rafaels request, I shall 
be retesting with the latest 2.6.25-rc kernel on Saturday.  I look 
forward to getting it fixed - I know it should be possible because it's 
a regression.

Alan
