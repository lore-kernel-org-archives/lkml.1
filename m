Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYGaKYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYGaKYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYGaKYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:24:16 -0400
Received: from smtp6.versatel.nl ([62.58.50.97]:35648 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYGaKYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:24:15 -0400
Message-ID: <489194DC.4020000@hhs.nl>
Date: Thu, 31 Jul 2008 12:33:00 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RESEND x9+ patch 2.6.26-git 1/2] lm75: cleanup
 and reorg
References: <200807251523.28242.david-b@pacbell.net>	<20080729233231.0ced6d9b.akpm@linux-foundation.org>	<48901BF7.9050601@hhs.nl> <20080730004615.f0686916.akpm@linux-foundation.org>
In-Reply-To: <20080730004615.f0686916.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> OK.  Can you please email me any patches which you think should be in
> 2.6.27 in the usual manner, with the appropriate mailing list cc's?  Add
> your own signed-off-by: if needed.  I'll get it all lined up.
> 

Done for the abituguru3 patch, as for Jean's new style driver conversion 
patches I think thats best done by Jean himself.

I also have a patch adding pwm control support to the fintek f71882fg on my to 
review list (I'm the maintainer of the f71882fg driver) I've already tested it 
and I'll try to get that reviewed the next couple a days and then send it to 
you for 2.6.27 inclusion.

Then there also are 2 new hwmon drivers which really have been waiting to long 
to get into the kernel too. I'll try to review those too, but I can test only 
one of them. Let me know if not being able to test the other is a problem for 
upstream inclusion.

Regards,

Hans
