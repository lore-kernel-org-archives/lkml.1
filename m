Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZKPUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZKPUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZKPUh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:37:26 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:26969 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZKPUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:37:26 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B01B804.6070809@tremplin-utc.net>
Date: Mon, 16 Nov 2009 21:37:24 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, daniel@caiaq.de, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 00/10] LIS3: Feature updates and corrections
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>	<4B0025DE.8050402@tremplin-utc.net> <20091116120327.7dd04a0d.akpm@linux-foundation.org>
In-Reply-To: <20091116120327.7dd04a0d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 16-11-09 21:03, Andrew Morton schreef:
> On Sun, 15 Nov 2009 17:01:34 +0100
> __ric Piel<eric.piel@tremplin-utc.net>  wrote:
:
>> Andrew, maybe you could already queue the first 5 patches, as they all
>> look fine and are fixing bugs. So we are sure they are there for 2.6.33
>> :-) The rest of the patch series is useful but just "new feature" and
>> some need more work.
>
> OK, I merged the five.
>
> We could sneak some/all of them into 2.6.32 I guess, if you think
> that's warranted?
Well, if it's not too late, it would be worthy, as they are fixing bugs, 
some of them actually affecting users. At least the first 4 should be 
very safe.

> The ones which were From:yourself were missing Samu's Signed-off-by:.
> I added it.
Thanks
>
> "[PATCH v2 04/10] lis3: fix show rate for 8 bits chips" has a poor
> changelog.  "fix with 8 bits sensors".  It failed to tell us what the
> bug was, what its user-visible effects were, how it was fixed.
Yes, I actually resent it with a better changelog yesterday:
http://lkml.org/lkml/2009/11/15/91

I should have highlighted it in my previous email. Could you pick this 
one instead?

Thanks,
Eric
