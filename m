Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXHCBxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXHCBxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbXHCBxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:53:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:52259 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbXHCBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:53:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EPLX59JN5d1A+2J+pn0z4cEySEdmPKmedswUTBPulewbofYMdaljXlw2AmrhXJ2xq7dhyH2V6f4kJ6ewxr1ZYGL7bMfMCCKMYOHmvzvyf3X/6xI6l1E5DAxQaW9vDL0xwdxWeGJLGzK2dv5rrVaj5pDmfJ3uRiZr98eN8wZcLi8=
Message-ID: <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
Date: Fri, 3 Aug 2007 01:53:34 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
	 <20070801055845.GA2648@infomag.infomag.iguana.be>
	 <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/1/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> >On 8/1/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> > Hi Dave,
> >
> > > config eurotechwdt to yes will cause system silent reboot. Is it right
> > > behaviour or a bug?
> >
> > I think this might be a bug. I'll look at the code and will ask you to do some
> > tests for me (if that is ok for you).
> >
> I'm ok for me. BTW, the rebooting is too quick that I have to set the
> boot_delay command line parameter to see it.
>

Hi,
News: 2.6.23-rc1-mm1 will reboot with eurotechwdt, but 2.6.23-rc1-mm2
will not. do you need the config files?

I will concentrate on this problem as well. Any hints how to debug?

I add andrew to cc.

Regards
dave
