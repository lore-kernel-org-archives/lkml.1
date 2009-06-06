Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZFFVQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZFFVQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZFFVQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:16:27 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39494 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZFFVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=CmPI+hsoWJ2dr6dpFbMPx8GbHT9d52vXt/szBaLrizdHS0G6yGtsl39jFWP2gQhgUA
         Q3X8wfeWzNtv5ygE0wU4jnS/Qxn/zscEZ4UHz6T8lAoixIQwEpyUCw0/Fmljhnmk8bWm
         HciRsjNnxF+RvzjUEUdNsHf3RIIZt0jBODu8E=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Sat, 6 Jun 2009 22:15:30 +0100
User-Agent: KMail/1.9.10
References: <200906061959.55592.chris2553@googlemail.com>
In-Reply-To: <200906061959.55592.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906062215.30571.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I've just realised what a poor report my earlier email was. I should also have said that the 
kernel has booted succesfully. At the time of reporting I had had two panics. I've just done 
another git pull, so the kernel is bang up to date with kernel.org, but after building and 
installing, a reboot resulted in another panic. The system then booted OK after switch off and on 
again.

Please cc me to any reply, I'm not subscribed.


On Saturday 06 June 2009, Chris Clayton wrote:
> Hi,
>
> After a git pull earlier today, I've had oopsen whilst booting the system
> twice today: A photo of the oops message can be viewed at:
>
> http://img231.imageshack.us/img231/8931/dscn0610.jpg
>
> I haven't used the 2.6.30-rc kernels very much, so I don't have a clue when
> the problem was introduced. I have no problems at all with 2.6.29.4.
>
> Happy to help solve this - just let me know what else I can do.
>
> Thanks



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
