Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFPTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFPTH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYFPTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:07:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:60084 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYFPTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=C6imfHtuKN43cw4EyEGOkal7SAvZP5nnNlQRn/iaBbULzy4kQOO789WDjINQCvd/lW
         qpOhVczhJNUwoPCwBvNCvirCgV3dJzkqmM9qsXG6xU8kLmuMIs+x/QrwmszGFqrRLNF5
         k4zXEUJ/JPYArU/Wpv2YSmtZ2qyYxYwt6L5gY=
Message-ID: <4856C7D8.4040508@gmail.com>
Date: Mon, 16 Jun 2008 20:06:48 +0000
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080528)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: trenn@suse.de, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres
 enabled
References: <1213638474.1684.21.camel@queen.suse.de> <4856A8E0.4060408@zytor.com>
In-Reply-To: <4856A8E0.4060408@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Thomas Renninger wrote:
>>   - This affects AMD Mobile Semprons (at least 3500+ and 3600+)
>>
>> This seem to be a mainline kernel regression since the nohz/highres
>> patches have been added.
>> I do not own such a machine myself (Richard, Evgeny, Uli (and Anvin?)
>> have such a machine and already helped to come that far).
>
> 'Fraid I don't.  :(
>
>     -hpa
>
I can help out as needed, just a work deadline I have to meet so I 
haven't been able to dig further.  Just point me in the direction and 
I'll gladly be someones hands on the beastly machine :-)

Richard
