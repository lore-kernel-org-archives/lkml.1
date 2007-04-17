Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXDQHhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXDQHhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXDQHhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:37:54 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:25346 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXDQHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sI6tybAeI8PvMSeOJD6dgevL3Y0fflpNsfI6SnTSDFal1AqunOT+R6KpEqgD9mRaWN/SNvX5lC9IkMMqdbzVxDrCxiZPm4dAfjjlcIelzBwhbe1lJiu4eypfUTq+hWf4XQ7SvSB6fTZ6vHULln25DGmuNIrf/IbuUPOtPJS31dM=
Message-ID: <b637ec0b0704170037r10b27116mb605eeda6b1e145b@mail.gmail.com>
Date: Tue, 17 Apr 2007 09:37:51 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <4623F804.3020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <461D4E2C.6000704@redhat.com> <20070414105255.GB9157@ucw.cz>
	 <20070415155343.GA12069@khazad-dum.debian.net>
	 <Pine.LNX.4.61.0704152050150.27018@yvahk01.tjqt.qr>
	 <4623F804.3020405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 4/17/07, Chuck Ebbert <cebbert@redhat.com> wrote:
<snip>

> (2) Linux (alone) gives a very muted pop on shutdown. This could
>     be from bad interaction with the shutdown command, or some
>     other reason (drive not given enough time to shut down?)
>     The noise is not very loud, maybe the head did not have to
>     move very far?
>

I'm facing this with my HP Pavilion DV4378EA with a PATA disk (Toshiba
I think, but I'm not too sure, will check in the afternoon if needed).
"The Other OS" does not  cause the "pop" at shutdown. Linux does (last
checked: yesterday with 2.6.21-rc7).

I'm happy to test patches.
Regards,
Fabio
