Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYCYPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYCYPqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYCYPqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:46:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:5120 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYCYPqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=VIMwaDhybGBjfLqoIi7JXSpPQ4zicveoIX13TsYW+bkQzTpC21FHIJdu7PTRPfZn/PLNdKMzbqKaYbsz3S2ZHINf3kIT+osROHvoqdkjuLYuUw/aJGafVIXzr4wzayfJn2gPWJUSp3CoDU/rEwkIF3bqUtB5q24jo6wTGItAc4o=
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: Spammed logs again rt2500pci 2.6.25-rc6-00268-gd2532dd
Date: Tue, 25 Mar 2008 16:35:36 +0100
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20080117225744.29aa214c@Varda> <200803251441.22394.IvDoorn@gmail.com> <20080325160848.6dc3584f@Varda>
In-Reply-To: <20080325160848.6dc3584f@Varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803251635.36857.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008, Alejandro Riveira Fernández wrote:
> El Tue, 25 Mar 2008 14:41:22 +0100
> Ivo van Doorn <ivdoorn@gmail.com> escribió:
> 
> > Hi,
> > 
> > >  Linux Varda 2.6.25-rc6-00268-gd2532dd #1 SMP PREEMPT Mon Mar 24 14:44:13 CET
> > > 2008 x86_64 GNU/Linux
> > > 
> > > 
> > >  As the last time the thing is triggered with a p2p app making a lot of
> > >  connections deluge
> > >  
> > >  My logs are spammed with the same msgs as other reports.
> > >  If you need more info just ask.
> > 
> > This issue has been resolved for 2.6.26. The fix for this bug is of such a scale
> > that it could not easily be merged for 2.6.25.
> > 
> > >  PS: i will not bother to make a report in the web forums becouse the last time
> > > i was ignored.
> > 
> > You mean http://rt2x00.serialmonkey.com/phpBB2/index.php?
> > 'ignored' is not the right word, more likely overlooked.
> 
>  Fair enough; english is not my mother tongue so maybe i sounded
> harsher than intended. If that's the case my apologies

Ok.

> > There are quite a lot of messages and I don't always have time to answer them all.
> > So there is no need to be upset about such thing, simply posting a reminder is usually
> > enough to make it noticed by me...
> > 
> > > (Someone may want to change the web forums pointer in the logs to 
> > > the linux-wireless mailing list)
> > 
> > What pointer? And rt2400-devel is the mailinglist for rt2x00...
> > The MAINTAINERS file in the kernel tree indicates 2 mailinglists for rt2x00:
> > 	rt2400-devel@lists.sourceforge.net
> > 	linux-wireless@vger.kernel.org
> 
>  Well my opinion is that instead of the webpage the mailing list should be the
> one being logged. Something like this (maybe use another define becouse
> DRV_PROJECT may be used elsewhere i havn't checked):

Well DRV_PROJECT is the link to the website, that contains more information
about the project. When people want to report bugs they can choose to
use the bugzilla, forum or mailinglist.
So I don't see a big point in replacing the link.

Ivo
