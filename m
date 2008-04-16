Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbYDPCub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbYDPCub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYDPCuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:50:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:6331 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYDPCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Y+l/KwTCzt5tCJFxWuMQ7hO3uEJGOD/Ql2eEP7SMrgw05LnSAIyjrWg8o9IK3Oq860lyscG93o6wmJ8JdGVUyU9OFKJSEgdLAteu0mUsuEs2Utltv25QAGyWzItdOxOHMumdu6/99Xt5ei2OxGNhkL4m7bWw2mvWGRiaQI5XLOY=
Message-ID: <48056942.5010106@gmail.com>
Date: Tue, 15 Apr 2008 21:49:38 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Daniel Barkalow <barkalow@iabervon.org>, Arnd Bergmann <arnd@arndb.de>,
       Alexia Death <alexiadeath@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com> <200804140848.39226.arnd@arndb.de> <480343F2.3040401@zytor.com> <alpine.LNX.1.00.0804151910100.19665@iabervon.org> <48055FC7.2020100@zytor.com>
In-Reply-To: <48055FC7.2020100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Daniel Barkalow wrote:
>>
>> Somewhat unsurprisingly, not all manufacturers took into account the 
>> possibility that a card would use a different block size than what all 
>> of the cards of the time used.
>>
> 
> What's really kind of pathetic is that designed, in 2000, a that broke 
> at 1 GB...
> 
>     -hpa

I have used 2 different 2GB cards, one works with a reader that it came with, 
the other won't work with the reader the other card came with, I did not try the 
switch the other way, but it appears that the cheap readers included with the 
cards are not interchangeable as they cut too many corners in the testing to 
make them nice and cheap.

                                 Roger

