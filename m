Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZHEFRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZHEFRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZHEFRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:17:01 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:23373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbZHEFRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UkSfZ10l3vUBEwZCCb69rpKD9Wlor47ArIm+h+ER9WTfGjLbypHwDcmgepPdqmG3D1
         PkB2RZZaF9/87UR4/q8l7ZMUPLdZ8hjpL0JXpmGbeQSmndUlYfcueJ6mY0qclvXeVr7M
         Kob3aKfKbw+ZmBM2dwiV2+xISszHf4U2SaWjY=
MIME-Version: 1.0
In-Reply-To: <1249405306.3094.18.camel@localhost.localdomain>
References: <20090803.132924.151782729.davem@davemloft.net>
	 <1249343666.3094.12.camel@localhost.localdomain>
	 <20090803.191916.75688176.davem@davemloft.net>
	 <20090803.211136.00343745.davem@davemloft.net>
	 <1249405306.3094.18.camel@localhost.localdomain>
Date: Wed, 5 Aug 2009 13:16:59 +0800
Message-ID: <a8e1da0908042216u16037395k96cce0746baa504e@mail.gmail.com>
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>, oliver@hartkopp.net,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 1:01 AM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Dave,
>
>> >> do you mind at least waiting for an ACK from my side. I haven't even
>> >> looked at the final patch.
>> >
>> > Sure, I haven't pushed it out yet, so now's your chance :)
>>
>> Grumble, I accidently pushed my net-2.6 queue out before you
>> had a chance to reply, sorry :-(
>
> not a big deal. Just have to send a cleanup patch. The patch itself is
> fine, but from a style perspective it is different than everything else
> in the Bluetooth subsystem and I would have liked to fix that before
> pushing it. I wait with that for 2.6.32 since it is not important.

Marcel, could you publish the bluetooth subsystem coding style
somewhere? People including me are confused about it. I remembered I
asked it from you, but it is still not very clear for me.

>
> The other Dave, please send patches to linux-bluetooth only and lets
> follow the normal path to get them merged into Linus' tree. Skipping
> bluetooth-2.6 is not an option. You have to use the same process than
> everybody else.

Why linux-bluetooth only? IMHO there could be more people to comment
and review  if I send patches to both lkml and subsystem mailing list.

>
> Regards
>
> Marcel
>
>
>



-- 
Regards
dave
