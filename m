Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXCNLa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXCNLa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXCNLa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:30:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:47705 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXCNLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DZv/ilnl3+qCD1zuNSV9+TJoLaKqQaIkYC7qz/ZD2vp9sCwYSLaWXlmLMEmrHaaIk1PcFp5yLe47jXXPmE+v3ZlN78EHwAnHMwrc0ufax6dSkX/FZxZ5jICO5d1ryOCe01mGl3js2LLGpC9VgrvfUkFLXxqbw4HfGbbs9J0aHbM=
Message-ID: <6bffcb0e0703140430i2202f14dw1681d5c70c1d4e28@mail.gmail.com>
Date: Wed, 14 Mar 2007 12:30:55 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y
Cc: Nilshar@gmail.com,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070314041710.770708c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>
	 <20070314041710.770708c4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 14 Mar 2007 03:13:25 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=8040
> >
> >
> >
> >
> >
> > ------- Additional Comments From Nilshar@gmail.com  2007-03-14 03:13 -------
> > Any news on that bug please ?
>
> None whatsoever.  Three people are reporting this and it's a drop-dead
> showstopper for a 2.6.21 release so we just have to wait until someone
> wakes up and thinks about it.
>
> It would be very useful if one of the reporters could perform a git-bisect
> search to identify the offending change, please.
>
> I would dearly like to point you at a document or web page which describes
> kernel-git-bisect-for-newbies, but afaik there isn't such a thing, which is
> a huge failing.

"Linux testers handbook" should be translated in a few weeks.

Here is a "git-bisect basics" movie :)
http://www.youtube.com/watch?v=R7_LY-ceFbE

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
