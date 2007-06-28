Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbXF1DEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbXF1DEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763248AbXF1DE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:04:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:47682 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbXF1DE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Kb/F0k04HtbMf3DZWsgnZngTqN6ueB6PrUjGmnhs8/cM4yj8EzuCw7K18mmjQ4Y7UyZBKv3P1hn+mtEuvWxgrFUAyRRR1b1WkuJPuKLTFGS7kBm+g0FUCxGMTwoeNHSwl5geFUBvALUZKCFtMEDVNpuRZJ+CdOHJlK0yphZigrc=
Message-ID: <4683252B.9010205@gmail.com>
Date: Wed, 27 Jun 2007 22:04:11 -0500
From: Patrick Draper <pdraper@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com>
In-Reply-To: <468315AF.1080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> So -- the fact that mixing actually works for you when using libaoss 
> means software mixing is working correctly for your ALSA setup. The only 
> thing you should do is _use_ ALSA (natively) and not its OSS emulation 
> so you can drop the library preload.

Cool. How do I go about figuring out what every app uses? For example, 
you mentioned that the flash 9 plugin, which I also use, is an ALSA 
aware application. How do you know? I need the check out everything that 
I use which needs sound (vmware, skype, kmplayer, etc.) I don't have 
source code for at least two of those.

Thanks,
Patrick
