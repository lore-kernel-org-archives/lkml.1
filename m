Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZBHWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZBHWF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZBHV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:58:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:60345 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZBHV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MeOyQkYy4lDcvZIKA7aTvbl1N+UiImR/eNKpMdGeyX37D7euxaVTVczCAuMECrj1y1
         +v8PGsyXj787GG3axr6gPXG2JAUlMxHTjyy7Zfqe0ho7d43Wlpw2zYGMJavF5LzJb1xI
         UL0e2Tw08gSW4+JYeViu2g7ciEy2ktbUsWoB0=
Message-ID: <498F558F.109@gmail.com>
Date: Sun, 08 Feb 2009 22:58:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
References: <1228749555-21363-1-git-send-email-jirislaby@gmail.com> <200812091453.32105.jbarnes@virtuousgeek.org>
In-Reply-To: <200812091453.32105.jbarnes@virtuousgeek.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, December 08, 2008 7:19 am Jiri Slaby wrote:
>> Let it as serial, since it doesn't have subdevice in the form of 0x00PS.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Applied to my linux-next branch, thanks.

Hi, did this get lost by a chance? I don't see it in your -next branch
anymore. Neither in any other branch nor upstream.

BTW I got:
This patch was dropped because it was merged into mainline or a subsystem tree
from Andrew, so it had to be somewhere, I suppose...
