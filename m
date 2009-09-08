Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZIHVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZIHVqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZIHVqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:46:52 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:51703 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZIHVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:46:51 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 17:46:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bhezbhUz1HzBH+YerLasFHvVHkh7vraRdNA+5zrS0jo+avHWQDRhqERBGF9i7MixJn
         PQuhxujc8emnaNgnZM5wRmd/c0c+t/ICtylC7q1lcLJqZoyqaSLAIuiVyjMmm2zrGx4s
         WWVPF8OxM83kFn/1YERXb4WIYhieoNsbuVVLw=
MIME-Version: 1.0
In-Reply-To: <200909082311.52229.elendil@planet.nl>
References: <20090906205952.GA6516@elte.hu>
	 <20090908013133.59203403@infradead.org>
	 <200909082222.44828.elendil@planet.nl>
	 <200909082311.52229.elendil@planet.nl>
Date: Wed, 9 Sep 2009 06:40:45 +0900
Message-ID: <49b7c2350909081440s527caeb4r25671f991a18109e@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: GeunSik Lim <leemgs1@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, realnc@arcor.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 6:11 AM, Frans Pop<elendil@planet.nl> wrote:
>> Would it be possible to have a command line switch that allows to start
>> the old textual mode?
> I got a private reply suggesting that --nogui might work, and it does.
Um. You means that you tested with runlevel 3(multiuser mode). Is it right?
Frans. Can you share me your linux distribution for this test?
I want to check with same conditions(e.g:linux distribution like
fedora 11,ubuntu9.04 , runlevel, and so on.).
> Thanks a lot Nikos!
>> Looks like the man page needs updating too :-)
> So this definitely needs attention :-P
> Support of the standard -h and --help options would be great too.
> Cheers,
> FJP
> --

Thanks,
GeunSik Lim.



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
