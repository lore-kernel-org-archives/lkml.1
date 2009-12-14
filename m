Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZLNAnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZLNAnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZLNAnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:43:21 -0500
Received: from claw.goop.org ([74.207.240.146]:42874 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbZLNAnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:43:20 -0500
Message-ID: <4B258A27.3050006@goop.org>
Date: Sun, 13 Dec 2009 16:43:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: liu weni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: [PATCH v2]kernel: remove mess codes
References: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com> <4B249210.7060103@goop.org> <20091214003320.GA29218@verge.net.au>
In-Reply-To: <20091214003320.GA29218@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/09 16:33, Simon Horman wrote:
> On Sat, Dec 12, 2009 at 11:04:48PM -0800, Jeremy Fitzhardinge wrote:
>    
>> On 12/12/09 22:55, liu weni wrote:
>>      
>>> I found some mess characters(0x0c) in the kernel source code.
>>> Then I suggest remove it.
>>>        
>> Those are form-feed characters.   Some editors use them to separate
>> logically distinct blocks of code into separate "pages".
>>      
> I can see their value in documentation, but I struggle to imagine
> their usefulness in code.
>    

I think a folding editor can fold them out, so you can just expand the 
area you're interested in.  Or something.  The point is that it is 
formatting that was presumably put there by the original author.  Unless 
they're actually upsetting something, I'd be inclined to leave them.

     J

