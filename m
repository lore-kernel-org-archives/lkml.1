Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbZGHEpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbZGHEpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZGHEpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:45:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:57597 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbZGHEpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uu1DLs1pyJPZ26RIeH/g5A3dn9XpOz4qc7+/pL1a7n86EOfeSdrz8DsmW1otDc5Z8o
         ggEN2qjc78cbaM1OgjBmhMZlTboy5Wj/EFnFpMAqAbGJzhQzW43lcbreB6PEHt1Hludr
         g4sjeaW2ABYS1f/33q9vJpjLiDOIhhaZkdQQw=
Message-ID: <4A5424C5.10405@gmail.com>
Date: Tue, 07 Jul 2009 21:47:01 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: mactel-linux.org-users@queuemail.com
CC: mactel-linux-users <mactel-linux-users@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Mactel-linux-users] touchpad synaptics pm-suspend
References: <4A53C580.2040000@queuemail.com> <4A540461.1030204@gmail.com> <4A541D42.8070004@queuemail.com>
In-Reply-To: <4A541D42.8070004@queuemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paul s wrote:
>
> i have not, just what is in the repository for the distribution...
>
>
>
> On 07/07/2009 10:28 PM, Justin P. Mattock wrote:
>> paul s wrote:
>>> hi -
>>>
>>> when my mbp4,1 comes back from suspend the touchpad is
>>> frozen|unresponsive|not working. it only seems to be with suspend as
>>> when it returns from hibernate it is fine...
>>>
>>> i am using 2.6.29.5-191.fc11.x86_64 is anyone experiencing this 
>>> issue...
>>>
>>> i have been looking around, played with the fdi and also added a script
>>> to the /etc/pm/sleep.d to load and unload appletouch to no avail...
>>>
>>> cheers
>>> paul
>>>
>>> ------------------------------------------------------------------------------ 
>>>
>>> Enter the BlackBerry Developer Challenge
>>> This is your chance to win up to $100,000 in prizes! For a limited 
>>> time,
>>> vendors submitting new applications to BlackBerry App World(TM) will 
>>> have
>>> the opportunity to enter the BlackBerry Developer Challenge. See 
>>> full prize
>>> details at: http://p.sf.net/sfu/Challenge
>>> _______________________________________________
>>> Mactel-linux-users mailing list
>>> Mactel-linux-users@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/mactel-linux-users
>>>
>> have you tried the latest stable kernel?
>>
>> Justin P. Mattock
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Not sure for redhat, but if you feel comfortable,
try just grabbing  a fresh tar.ball from kernel.org,
or use git to pull the latest from Linus's tree.
(this way your  up-to-date, and the fix could be already
in there).

Justin P. Mattock


