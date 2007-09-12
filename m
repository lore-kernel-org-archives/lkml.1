Return-Path: <linux-kernel-owner+w=401wt.eu-S970649AbXILRfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970649AbXILRfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966903AbXILRfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:35:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:61015 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764733AbXILRfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FfO4JCfTtork8HA0Cso5kii5J52a+fQqiC8zNTf6nFfLkbzeAhPr4Y7ky/xP2mAKoJfmbt7lXwZRpKAdBNxJ99vvNwOX1Q18fVp1CO5nC4xcbr4n9t8bpHqI0J6gm992FAJoWjbdLww+2LErPnp2DpljUWiq4+e5fj9xQMWs0H4=
Message-ID: <6bffcb0e0709121035t2e498273r1367074da8dce76@mail.gmail.com>
Date: Wed, 12 Sep 2007 19:35:21 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: 2.6.23-rc6: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, "Greg KH" <gregkh@suse.de>,
       "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070912171253.GB3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46E81AE2.8030802@googlemail.com> <20070912171253.GB3563@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2007, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Sep 12, 2007 at 06:59:14PM +0200, Michal Piotrowski wrote:
[..]
> > USB
> >
> > Subject         : build #246 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/usb/misc/phidgetservo.ko
> > References      : http://lkml.org/lkml/2007/9/11/211
> > Last known good : ?
> > Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> > Caused-By       : ?
> > Handled-By      : Adrian Bunk <bunk@kernel.org>
> > Patch           : http://lkml.org/lkml/2007/9/11/284
> > Status          : patch available
>
> Not a 2.6.23-rc regression

Ok, I removed it from the list.

> (but IMHO the patch should be safe enough
> for 2.6.23).
>
> cu
> Adrian
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
