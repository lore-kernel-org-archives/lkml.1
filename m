Return-Path: <linux-kernel-owner+w=401wt.eu-S1030878AbXDJPqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878AbXDJPqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030888AbXDJPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:46:11 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:56758 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030878AbXDJPqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:46:10 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 11:46:09 EDT
Message-ID: <461BB006.9020308@hhs.nl>
Date: Tue, 10 Apr 2007 17:40:54 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position
 is	open
References: <20070410150227.1bac05b5@hyperion.delvare>
In-Reply-To: <20070410150227.1bac05b5@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi all,
> 
> I am resigning from my role as hardware monitoring subsystem
> (drivers/hwmon) maintainer. This is too much work for me, I do not have
> the necessary bandwidth to review all the incoming patches, in
> particular new drivers, in a timely manner. Patch authors have been
> complaining about this repeatedly. This is no fun for them, and even
> less for me, so I'd rather let someone else with more spare time take
> care of it. If there are volunteers, this is the right time to speak up.
> 

I'm sorry to hear this and I can't help but think that my, erm, rant* yesterday 
is somehow involved in you making this decision. This was in no way my 
intention. My intention was to try and make you change how you handle these 
things, my intention was to make you less of a perfectionist and to distribute 
the work more, you cannot do everything yourself. I think that if you could 
change that you would be able to cope with the load better.

I think you're experience / knowledge when it comes to hwmon stuff is very 
valuable and if you leave / quit doing hwmon stuff this would be a big loose. I 
also believe that with a looser management style, you could seriously reduce 
your workload coming from being the hwmon maintainer and at the same time get a 
better / faster flow of patches.

But alas, I'm afraid I cannot change your mind, so that brings us to the 
question who will pickup the task. I've considered volunteering myself, but I'm 
to inexperienced when it comes to kernel stuff and lm-sensors for me is kinda a 
side project. I sink most of my spare time into Fedora where I maintain circa 
120 packages, which really means I have little time left for lm-sensors (to be 
clear the average package maintainer maintains between 30 - 50 packages).

However I do hereby promise to help the new "Jean" in anyway I can, and 
although not many know me very well here I think I can safely say I can help in 
many ways. I'm a (very) experienced c-programmer specialised in lowlevel code, 
embedded (linux) systems, etc. and I have a bachelor in electronics. So 
who-ever becomes the new "Jean" don't hesitate to ask for help, the worst thing 
that can happen is that I say no :)

Jean, thanks for all your hard work the past years!

Regards,

Hans

* for those not on the lmsensors list I am one of the complaining patch authors

