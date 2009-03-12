Return-Path: <linux-kernel-owner+w=401wt.eu-S1751660AbZCLXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbZCLXds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZCLXdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:33:39 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:1213 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZCLXdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:33:39 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 19:33:38 EDT
Message-ID: <49B99828.3090002@linuxtv.org>
Date: Thu, 12 Mar 2009 19:18:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jarod Wilson <jarod@wilsonet.com>, LMML <linux-media@vger.kernel.org>
Subject: Re: Fwd: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
  video_open
References: <200902241700.56099.jarod@redhat.com>	 <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com> <1236899033.3261.7.camel@palomino.walls.org>
In-Reply-To: <1236899033.3261.7.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls wrote:
> On Thu, 2009-03-12 at 16:24 -0400, Michael Krufky wrote:
>   
>> Can we have this merged into -stable?  Jarod Wilson sent this last
>> month, but he left off the cc to stable@kernel.org
>>
>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>     
>
> Mike,
>
> A version of this is already in the v4l-dvb hg development repository:
>
> hg log -vp --limit 1 linux/drivers/media/video/cx23885/cx23885-417.c
> hg log -vp --limit 2 linux/drivers/media/video/cx23885/cx23885-video.c 
>
> I helped Mark work through the solution: I coded some of it, he coded
> some of it and he also tested it.
>
> Regards,
> Andy

I'm aware of that, Andy -- That's why I am sending this off to the 
-stable team for 2.6.27.y

Thanks & regards,

Mike
