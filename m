Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZF3FbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZF3FbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZF3Far
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:30:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:62966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZF3Fap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NnZPt5rz7J8i9D5v2X+msB6lPh7zz5epjSwuVbTfG5/fJxF+VAR/JLW6sbvQRpLWrx
         yG0ib82j2ENxW3EbzckHGOCEDoUV8oWKTj83wabBAip/vHzc9X0lfgBVa1BdL/iMFXGD
         QF4mGhi9g4sSRNljbsf6IgrqMUaltUnb1b+iQ=
Message-ID: <4A49A349.8030702@gmail.com>
Date: Mon, 29 Jun 2009 22:31:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: need help figuring out what makes my wireless"iwconfig" not respond
References: <4A499531.4040001@gmail.com> <4A49980E.2010405@lwfinger.net>
In-Reply-To: <4A49980E.2010405@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Justin P. Mattock wrote:
>    
>> from 2.6.31-rc1 to present there was a couple of commits for
>> wireless. prior to that the wireless on my machine(imac)
>> was o.k.,
>> Now the wireless does work(streams music,t.v. etc..)
>> but when I look at iwconfig there's nothing no info.
>> (I use wicd as my connection manager, and in the bottom corner
>> of the screen the transmit power is down to almost nothing,
>> causing wicd to constantly reconnect)
>>
>> out of a random guess what commit might have caused this, so I can at least
>> fix this over here(that is until the manufacturer comes out with a new
>> version). I can go in and individually revert all of the wireless, but
>> before that
>> I want a quick lead.
>>
>> any ideas?
>>
>>      
>
> If you have a git tree, use the "git bisect" commands to find the bad
> commit.
>
>    
alright. I'll give that a try.

Justin P. Mattock
