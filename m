Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZJWFdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZJWFdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZJWFdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:33:39 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:62605 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZJWFdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aoklvNymLPKE53GEAA8eNtLCQ6VdOZCdgCm+iN0DNIFcO19xtrEIZ/tLVCCMoeDdec
         xr4q5ydzOvd43K+uiiGGOIXuA7xKsPVOB4akadkT2/WPqV92mVq0M3P895vBwbK6/GLX
         DbQ0EbmTXR2/oyhe9m8XHUjs0samxarnWDj7g=
Message-ID: <4AE14030.5010304@canonical.com>
Date: Fri, 23 Oct 2009 13:33:36 +0800
From: Bryan Wu <cooloney@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Matthias Urlichs <matthias@urlichs.de>, smurf@smurf.noris.de,
       linux-usb@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UBUNTU: USB: option: TLAYTECH TUE800 support
References: <1256194836-15733-1-git-send-email-bryan.wu@canonical.com> <1256202285.7526.109.camel@kiste> <4AE117B3.3040807@canonical.com> <20091023045236.GA3390@merkur.ravnborg.org>
In-Reply-To: <20091023045236.GA3390@merkur.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Oct 23, 2009 at 10:40:51AM +0800, Bryan Wu wrote:
>   
>> Matthias Urlichs wrote:
>>     
>>> On Thu, 2009-10-22 at 15:00 +0800, Bryan Wu wrote:
>>>       
>>>> Add ID for Tlaytech TUE800 CDMA modem to the option driver.
>>>>
>>>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>>>>         
>>> Acked-By: Matthias Urlichs <matthias@urlichs.de>
>>>
>>>
>>>       
>> Thanks a lot, Matthias. Do you think we need to include this patch into 31.y stable release?
>> Since our 9.10 Ubuntu kernel is based on .31 kernel, we need to include 
>> this patch through stable release.
>>     
>
> What is it with the subject of this patch?
> It says: UBUNTU: USB: ...
>
> And I do not recall a subsystem named "UBUNTU" in the kernel.
>
>   

Sorry for that mess. I posted this patch to our Ubuntu kernel team 
review as well as upstream. But forget to remove that tag.
Please ignore that, need I resend a patch?

Thanks
-Bryan

