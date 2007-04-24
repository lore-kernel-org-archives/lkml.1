Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXDXMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXDXMuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031072AbXDXMuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:50:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:40930 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357AbXDXMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mBJQRU37x2Ck8eh9HtFBpk0MAVCDGqSfHhEu3Y0bSszNlE/j3lc8DESq0VotdM6mIHknCyoOhRuDa/vyurmcQYzTstxL4s6xwPT1bN8L9Ot5ffpElUUZXSfiZnj72SzpDI9/jJT/RJb7yPL6Jro9YcCEQ9Ygq0GSR73kbv7k+pg=
Message-ID: <6bffcb0e0704240550x2c47cd1ap8101a9b0db5c6c7d@mail.gmail.com>
Date: Tue, 24 Apr 2007 14:50:38 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "William Heimbigner" <icxcnika@mar.tar.cc>
Subject: Re: cpufreq default governor
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704241235560.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
	 <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
	 <Pine.LNX.4.64.0704241235560.25153@server.thyself>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> On Tue, 24 Apr 2007, Michal Piotrowski wrote:
>
> > Hi William,
> >
> > On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >>  Question: is there some reason that kconfig does not allow for default
> >>  governors of conservative/ondemand/powersave?
> >
> > Performance?
> >
> >>  I'm not aware of any reason why one of those governors could not be used
> >>  as default.
> >
> > My hardware doesn't work properly with ondemand governor. I hear
> > strange noises when frequency is changed.
> >
>
> That doesn't mean it isn't working, though.

I didn't say that cpufreq ondemand is broken. It's a hardware problem.

> I here weird noises if the cpu
> is clocked anywhere from 333MHz to 1GHz (sounds like an RD-D2 beeping
> noises in ultra high pitch?)

Yes, something like that.

>
>   William Heimbigner
> icxcnika@mar.tar.cc
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
