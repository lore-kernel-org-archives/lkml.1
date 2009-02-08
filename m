Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZBHV1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZBHV1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZBHV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:26:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:64197 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZBHV0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=RrkI4uMpVkfAsG6ThhWCI9SQR6BOGpjPsQB+eXnxZ37bsMV8fWYYEAaqE4FkI+ecJG
         hhR8j2yYVbmTNnAIl1gnT+6qsf3+kk0eRadnreRQmsfB8d59Jk+M6wFXusEOYIPSLBE8
         OjLsAeHVVQyPlNPutXm3ZfdCzUkkX2932n1gA=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902081320560.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>
	 <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
	 <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
	 <cfd18e0f0902081318p3b7efde5u3977a9fdadf3f542@mail.gmail.com>
	 <alpine.DEB.1.10.0902081320560.18839@alien.or.mcafeemobile.com>
Date: Mon, 9 Feb 2009 10:26:53 +1300
Message-ID: <cfd18e0f0902081326r25218f87p232ed3365d6414b2@mail.gmail.com>
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and 
	CLOCK_MONOTONIC?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Patch, not tested, below.
>>
>> (Has it been compiled?)
>
> Yes, it builds fine. I just haven't had time to test it ATM...

Ok.

Did you see my other comment in the previous mail?



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
