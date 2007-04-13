Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXDMUrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXDMUrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXDMUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:47:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:20689 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337AbXDMUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hPfFt4wVFw330rBQwtmkcsnqfvKJiTt3U5TAjhbhX16kg7wibScl7D63e5UUWQo6bgaXQkLAYFCaE1AGmTMab6WdbVP3aPTjEcusU2V1mM9Lxb0Welw8nfUSAz5kJwXQui3jgTa5BceFIpYnP183BWEfby7KnTPYjPBmimqF7EM=
Message-ID: <58cb370e0704131347qa3439b5u26c8532deac50cd2@mail.gmail.com>
Date: Fri, 13 Apr 2007 22:47:48 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <461FDBB4.8070208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <461D4E2C.6000704@redhat.com>
	 <Pine.LNX.4.61.0704112347230.20436@yvahk01.tjqt.qr>
	 <461D5C24.9080506@redhat.com> <200704132142.29582.bzolnier@gmail.com>
	 <461FDBB4.8070208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Bartlomiej Zolnierkiewicz wrote:
> >> Now we're getting somewhere. There is some other OS on here because
> >> it's required for doing BIOS updates. I booted it and shut down.
> >> The power cycle count increased but the power off retract count did not.
> >>
> >> The counts are:
> >>
> >> power cycle ... 111
> >> power off retract ... 92
> >>
> >> The difference is now 19; it was 18 before.
> >
> > Is the noise present if you reboot the other OS?
> > Does it result in Power-Off_Retract count increase?
>
> There is no noise and the retract count does not increase when I boot
> and then shutdown/power off the other OS.

What about shutdown/reboot?
