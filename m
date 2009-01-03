Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZACBdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZACBdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZACBcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:32:55 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:13523 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbZACBcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H3kM3owJvly4B+/5YJep05XMSttrtN7sUZu1yBLRfUwFTK1GMcC+Kj1SYhuIDgdHFk
         BG7pMeUaFTwO8XVShPaMi8B7r10IQXPK0XgFrZG5wgG9jAgMslZL6LctittSYh2GLxl9
         0r9hS2Fxp5u9l5w0hfifrZZCHLRBqZ8CbPdwA=
Message-ID: <495EC040.2070905@gmail.com>
Date: Fri, 02 Jan 2009 17:32:48 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: tux3@tux3.org, Martin Steigerwald <Martin@lichtvoll.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <200901021445.37062.phillips@phunq.net> <495E9F22.3080206@gmail.com> <200901021719.26680.phillips@phunq.net>
In-Reply-To: <200901021719.26680.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Friday 02 January 2009 15:11, Justin P. Mattock wrote:
>   
>> The game that came to mind when I first
>> heard of tux3(I had to google a bit to find the name)
>> was tux racer.  :^)
>> quick question:
>> what is the state for security file labeling for
>> SELinux on this filesystem?
>>     
>
> There is a lot of interest in security labels.  You are not the first
> to ask.
>
> Tux3 variable inode attributes are ideal for implementing security 
> labels efficiently, way more lightweight than extended attributes.  
> Otherwise, we would like to know exactly what people want.
>
> Regards,
>
> Daniel
>
>
>   
thats probably one of the main areas of
interest that I have in filesystems,
the ability to run a policy etc..
As for what people want, thats tough
to say, my guess would be file corruption,
then probably security etc..

regards;

Justin P. Mattock
