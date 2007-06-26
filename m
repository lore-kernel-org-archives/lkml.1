Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbXFZPLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbXFZPLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbXFZPLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:11:32 -0400
Received: from mail.xandmail.com ([212.155.184.97]:41551 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbXFZPLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:11:30 -0400
X-Greylist: delayed 2838 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 11:11:29 EDT
Date: Tue, 26 Jun 2007 16:24:07 +0200
Message-Id: <JK8YO7$ED15496EC345D64436196D8FF32F355E@xandmail.com>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "jarkao2" <jarkao2@o2.pl>, "marcin\.slusarz" <marcin.slusarz@gmail.com>,
       "shemminger" <shemminger@linux-foundation.org>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, i have a very similar problem with 2.6.21 also;

2 3com NICs and they are failling randomly.

The kernel is a basic fedora 7 kernel (2.6.21-1.3228.fc7)
I found a bug report and added details here : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243960

I'm not subcribed on this list, so please cc me if there is any questions.

JB

> On Tue, Jun 26, 2007 at 08:10:17AM +0200, Marcin Ślusarz wrote:
> ... 
> > I reproduced it on minimal config:
> ...
> 
> Hm... This method is usable if you can find such minimal config
> with which the bug cannot be reproduced. Then you can add more
> until the bug is back. Of course, this takes time...
> 
> We know your hardware should be OK - since it was fine with 2.6.20.
> We don't know how much your configs (kernel & apps) have changed.
> Sometimes the change of kernel needs some apps to be recompiled too.
> That's why it could be usable to try 2.6.21 from a live distro to
> find if it's really kernel's fault.
> 
> And, alas, this log doesn't seem to tell nothing new...
> 
> Regards,
> Jarek P.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

