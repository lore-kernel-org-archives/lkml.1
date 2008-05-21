Return-Path: <linux-kernel-owner+w=401wt.eu-S935805AbYEUPPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935805AbYEUPPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYEUPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:15:33 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:31627 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYEUPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:15:32 -0400
Message-ID: <48343C92.4090403@netone.net.tr>
Date: Wed, 21 May 2008 18:15:30 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
References: <48341ED5.7060508@netone.net.tr>	 <20080521063855.0bdb441c@infradead.org>	 <84144f020805210648y43efb024w8e2f28e62894b1d@mail.gmail.com>	 <48342B19.9040407@netone.net.tr> <170fa0d20805210732s24f2c188i75ab2ab2dab5aeb5@mail.gmail.com>
In-Reply-To: <170fa0d20805210732s24f2c188i75ab2ab2dab5aeb5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 15:13:05.0815 (UTC) FILETIME=[2B997270:01C8BB55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:
> I think you're missing Arjan and Pekka's point: your proposal doesn't
> _really_ offer any change to the current procedure.  It might make you
> feel more warm and fuzzy but in practice:
> 1) Linus would still release a kernel (be it to -testX or "final")
> when he and others feel it is time
> 2) The stable team will track fixes and release stable kernels as needed
>
> The only thing that is different in your approach is the "final"
>   
Yes, that's what I'm talking about. The change will be the "testX" 
thing. And as you already stated it will help more stable releases.
> release would theoretically be more well tested.  Unfortunately that
> is not a valid assumption because the wider Linux audience likely
> won't embrace the latest kernel until it is "final" anyway.  This
> delayed uptake can/will result in early stable fixes.
>
>   
Of course as didn't embrace like the "rc" releases. I don't think that 
it will cause early stable fixes. Contrarily, it will produce more 
tested/stable releases. You may think it as a kind of "rc" series.


> Again, no real change... we know that the "final" release that Linus
> makes _could_ have some minor oversight that will be fixed fairly
> quickly by the stable team.
>
> Mike
>   
It is. As I described above : the "testX" series will change the things 
as producing more tested /stable releases. BTW, it should be much better 
to release less, trouble free kernels instead of releasing fast but 
fixing soon. Also, it will take the load of deep kernel testing. Linus 
should only do the applying the patches for the next kernel release via 
"rc" releases. Then when Linus decided all the patches, for the next 
kernel, applied he will pass it to the "testX" series maintainer as 
Chris did for 2.6.x.y.



