Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZJWGuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZJWGuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 02:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZJWGuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 02:50:11 -0400
Received: from kroah.org ([198.145.64.141]:52650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZJWGuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 02:50:10 -0400
Date: Thu, 22 Oct 2009 23:49:42 -0700
From: Greg KH <greg@kroah.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Matthias Urlichs <matthias@urlichs.de>,
       smurf@smurf.noris.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UBUNTU: USB: option: TLAYTECH TUE800 support
Message-ID: <20091023064942.GB28430@kroah.com>
References: <1256194836-15733-1-git-send-email-bryan.wu@canonical.com> <1256202285.7526.109.camel@kiste> <4AE117B3.3040807@canonical.com> <20091023045236.GA3390@merkur.ravnborg.org> <4AE14030.5010304@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE14030.5010304@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 01:33:36PM +0800, Bryan Wu wrote:
> Sam Ravnborg wrote:
>> On Fri, Oct 23, 2009 at 10:40:51AM +0800, Bryan Wu wrote:
>>   
>>> Matthias Urlichs wrote:
>>>     
>>>> On Thu, 2009-10-22 at 15:00 +0800, Bryan Wu wrote:
>>>>       
>>>>> Add ID for Tlaytech TUE800 CDMA modem to the option driver.
>>>>>
>>>>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>>>>>         
>>>> Acked-By: Matthias Urlichs <matthias@urlichs.de>
>>>>
>>>>
>>>>       
>>> Thanks a lot, Matthias. Do you think we need to include this patch into 31.y stable release?
>>> Since our 9.10 Ubuntu kernel is based on .31 kernel, we need to include 
>>> this patch through stable release.
>>>     
>>
>> What is it with the subject of this patch?
>> It says: UBUNTU: USB: ...
>>
>> And I do not recall a subsystem named "UBUNTU" in the kernel.
>>
>>   
>
> Sorry for that mess. I posted this patch to our Ubuntu kernel team review 
> as well as upstream. But forget to remove that tag.
> Please ignore that, need I resend a patch?

No, I can edit that out, don't worry.

I'll apply this next week when I return from Japan.

thanks,

greg k-h
