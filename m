Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYG3HnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYG3HnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYG3Hm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:42:58 -0400
Received: from smtp6.versatel.nl ([62.58.50.97]:55163 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYG3Hm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:42:57 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 03:42:57 EDT
Message-ID: <48901BF7.9050601@hhs.nl>
Date: Wed, 30 Jul 2008 09:44:55 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RESEND x9+ patch 2.6.26-git 1/2] lm75: cleanup
 and reorg
References: <200807251523.28242.david-b@pacbell.net>	<20080729233231.0ced6d9b.akpm@linux-foundation.org>
In-Reply-To: <20080729233231.0ced6d9b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Minor cleanup and reorg of the lm75 code.
>
> This patch (and the other) have been in Mark's tree for a month or so. 
> (linux-next <- useful!)
 >
> Mark has been pretty, umm, low-key lately.  I've attached the full
> git-hwmon changelog below and the authors of all those changes are
> cc'ed.
>
> Could people please confirm that what is in linux-next is still the
> latest and greatest version of their changes?  If so, I shall plan on
> fishing those changes out of there and getting them into -rc2.

Andrew,

I see that atleast this patch:
http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023629.html

Is missing which is a minor yet somewhat important bugfix to the abituguru3 
driver, see:
http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023630.html

For my: "Acked-by: Hans de Goede <j.w.r.degoede at hhs.nl>" Line (I'm the 
maintainer of that driver).

It would be nice if this fix could make 2.6.27.


Also Jean has been doing a lot of patches for all i2c hwmon driver to convert 
them to new style driver binding, and I've reviewed and Acked the entire bunch.
So all in all it looks like we're dropping patches, does anyone know whats up 
with Mark, holiday or ... ?

Thanks & Regards,

Hans
