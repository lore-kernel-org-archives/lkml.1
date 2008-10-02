Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754895AbYJBRo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYJBRo2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 2 Oct 2008 13:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYJBRoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:44:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:20603 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJBRoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=TPk7Vifll1qTwonCTkh6UbWTHxJzmVReyii8CEwPcDg2gbjqMwxaSfVyhqpgXHiMC5
         Iv6Ib23isdqFlGRAIlxjbp+paq9S6+fE2DPWpuCqCwF91T+ENfi0NSZ7dOeomF1LAUYa
         0aa1yfYD5UbOG+aHLNSnjJkp8n+93ZDP55/Oo=
Message-ID: <48E50862.3030205@gmail.com>
Date: Thu, 02 Oct 2008 18:44:02 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Dave <kilroyd@googlemail.com>, Greg KH <greg@kroah.com>,
        TJ <linux@tjworld.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Casual J. Programmer" <casualprogrammer@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Alexander Shirshikov <alexander.shirshikov@gmail.com>
Subject: Re: Agere Hermes source-code: copyright situation
References: <200809290949.35749.arvidjaar@mail.ru> <20081001200039.GA29874@kroah.com> <48E400FA.2090305@gmail.com> <200810020637.27321.arvidjaar@mail.ru>
In-Reply-To: <200810020637.27321.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
>> FYI, Hermes I hardware is already covered by the orinoco driver. WPA and firmware download functionality (which is supported by the Agere driver, but not orinoco in 2.6.27) is already in the wireless queue for 2.6.28.
>>
> 
> Yes, I discovered this yesterday as well. Thank you!
> 
> How are you going to distribute firmware? You will need 9.x firmware from
> original Agere driver; do I understand it correctly that it will come
> with orinoco in binary form?

I was hoping we could get it into David Woodhouses firmware tree. However I haven't had a response to my original message. I'll try again with a patch.


Dave.
