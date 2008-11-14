Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYKNVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYKNVxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKNVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:53:06 -0500
Received: from ns1.suse.de ([195.135.220.2]:47654 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYKNVxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:53:03 -0500
Date: Fri, 14 Nov 2008 13:07:49 -0800
From: Greg KH <gregkh@suse.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Greg KH <greg@kroah.com>, "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081114210749.GA1022@suse.de>
References: <20081113230259.GA3681@kroah.com> <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com> <20081114191545.GA24115@kroah.com> <491DD440.9000402@ru.mvista.com> <20081114195948.GA25682@kroah.com> <491DDB38.9000109@ru.mvista.com> <20081114205511.GA833@suse.de> <491DE771.2070009@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491DE771.2070009@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 12:02:41AM +0300, Sergei Shtylyov wrote:
> Greg KH wrote:
>
>>>>>>> It should be [best_end < 0].
>
>>>>>>> If it is possible then please correct this mismatch in your series.
>
>>>>>> I'll wait to get a patch from Felipe for this.
>
>>>>>  I'm seeing it being to you sent at least a week ago -- look for "usb: 
>>>>> musb: fix bug in musb_schedule".
>
>>>> As Felipe is the maintainer of the musb code, and has been batching up
>>>> patches and sending them on to me when needed, I have only been taking
>>>> them from him.
>
>>>> So that message is long deleted from my mail, sorry.
>
>>>   Even though it was a message from him CCing you? :-)
>>>   Here it is: http://marc.info/?l=linux-usb&m=122605639520312.
>
>> Nope, I'm not on the CC: for that message, sorry, check your headers...
>
>    Sigh, here's an excerpt from its header (note that marc.info doesn't 
> show CCs at all):
>
> From: Felipe Balbi <felipe.balbi@nokia.com>
> To: linux-usb@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@suse.de>,
> 	Felipe Balbi <felipe.balbi@nokia.com>

Odd, digging through my linux-usb archive I see:

	Date: Wed, 12 Nov 2008 17:35:18 +0200
	From: Felipe Balbi <felipe.balbi@nokia.com>
	To: linux-usb@vger.kernel.org
	Cc: Felipe Balbi <felipe.balbi@nokia.com>
	Subject: [patch-2.6.28-rc3+ 8/9] usb: musb: fix bug in musb_schedule
	Message-Id: <1226504119-22995-9-git-send-email-felipe.balbi@nokia.com>


Anyway, I didn't realize I should have added it at the time.

I'll wait for Felipe to resend his queue as he said he was going to do.

Ah, if you go back further, now I see it:
	Message-Id: <1226056335-25598-1-git-send-email-felipe.balbi@nokia.com>

Oh well, that got purged after I saw his updated patch queue.

what a mess...

thanks,

greg k-h
