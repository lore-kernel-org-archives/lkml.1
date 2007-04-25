Return-Path: <linux-kernel-owner+w=401wt.eu-S1423388AbXDYVky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423388AbXDYVky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423381AbXDYVky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:40:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:39791 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423390AbXDYVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a0F/1JrOkB93sKHvQKhptg8s71BkB7GPEDra+UjRdH+BXAXzVo5/3QlAHnu0REsvOO9RmgDyuK1Tm7RuXFr37FTi3v3/pSLzBD+1qTa3DizprGfsskr/TGCtZ+EEao6GeyDsYt1OK2auN7XmwpiD96X7Vt8dOQikFcfBw0X8LDw=
Message-ID: <6bffcb0e0704251440l6149b50creafd4845c131be09@mail.gmail.com>
Date: Wed, 25 Apr 2007 23:40:51 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704252257.41950.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
	 <200704252248.03243.ak@suse.de>
	 <6bffcb0e0704251355r6de26273s47ba5c857ed0f129@mail.gmail.com>
	 <200704252257.41950.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/07, Andi Kleen <ak@suse.de> wrote:
>
> > Maybe because it's P4 HT?
>
> Shouldn't make a difference.
>
> Can you please: apply the latest patch from
>
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
>
> to a 2.6.21-rc7 kernel and then send me a full boot log?

Now everything looks OK
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/git-dmesg

>
> -Andi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
