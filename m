Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXEKNps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXEKNps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXEKNpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:45:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:49608 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PCQmsOjwQ+9XH9fUsrOlAkxjwEI593JLaOQZ9AK+V5ODqiBw4hxlYEQjX2OJDWFND6Imcs/x29mgrXqqvZlb07TUGrv+p5fyl/OxHwL4yZFAzj8+s+QpvbGMpnrA/5L7M2YGi+XNT5btXatOuCVqH+KFQp7zo61Nx+N4emPZ5X8=
Message-ID: <a781481a0705110645xbadcf6bhd86cd7e0345ee61b@mail.gmail.com>
Date: Fri, 11 May 2007 19:15:40 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Woodhouse" <dwmw2@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Anton Vorontsov" <cbou@mail.ru>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20070511142124.06aa2d2e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503213303.GH20067@zarina>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	 <1178646751.2824.48.camel@pmac.infradead.org>
	 <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
	 <1178721996.2824.199.camel@pmac.infradead.org>
	 <20070509203335.GA4290@ucw.cz>
	 <20070511142124.06aa2d2e@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Even with fbdev... you are limited to 512 characters iirc. So.. who
> > has authority to say which subset of utf-8 is ok?
>
> This is a bug in fbdev and currently under discussion as there is no sane
> reason to enforce the 512 symbol limit in the fbdev case (especially on a
> large modern system)
>
> > (Plus there is still lot of vga consoles out there -- all fedora users
> > afaict?)
>
> Fedora uses X.

I run FC5 and even _without_ X (on the tty1 console, for example), UTF-8
source files turn out just _fine_ indeed. And I checked vim, emacs and
*even* nano.
