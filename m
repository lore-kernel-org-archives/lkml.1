Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYKNVCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYKNVCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKNVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:02:44 -0500
Received: from h155.mvista.com ([63.81.120.155]:5276 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbYKNVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:02:43 -0500
Message-ID: <491DE771.2070009@ru.mvista.com>
Date: Sat, 15 Nov 2008 00:02:41 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
References: <20081113230259.GA3681@kroah.com> <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com> <20081114191545.GA24115@kroah.com> <491DD440.9000402@ru.mvista.com> <20081114195948.GA25682@kroah.com> <491DDB38.9000109@ru.mvista.com> <20081114205511.GA833@suse.de>
In-Reply-To: <20081114205511.GA833@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>>>>>>It should be [best_end < 0].

>>>>>>If it is possible then please correct this mismatch in your series.

>>>>>I'll wait to get a patch from Felipe for this.

>>>>  I'm seeing it being to you sent at least a week ago -- look for "usb: 
>>>>musb: fix bug in musb_schedule".

>>>As Felipe is the maintainer of the musb code, and has been batching up
>>>patches and sending them on to me when needed, I have only been taking
>>>them from him.

>>>So that message is long deleted from my mail, sorry.

>>   Even though it was a message from him CCing you? :-)
>>   Here it is: http://marc.info/?l=linux-usb&m=122605639520312.

> Nope, I'm not on the CC: for that message, sorry, check your headers...

    Sigh, here's an excerpt from its header (note that marc.info doesn't show 
CCs at all):

From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Felipe Balbi <felipe.balbi@nokia.com>

> thanks,
> greg k-h

WBR, Sergei
