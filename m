Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXFKGJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXFKGJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXFKGJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:09:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:44970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbXFKGJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:09:16 -0400
Date: Sun, 10 Jun 2007 23:07:59 -0700
From: Greg KH <gregkh@suse.de>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070611060759.GB914@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <466C3B64.4070806@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466C3B64.4070806@citd.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 07:56:52PM +0200, Matthias Schniedermeyer wrote:
>  Greg KH wrote:
> > On Sun, Jun 10, 2007 at 02:24:51PM +0200, Jesper Juhl wrote:
> >>  Since the common language of most kernel contributors is english I
> >>  personally feel that we should stick to just that one language in the
> >>  tree and then perhaps keep translations on a website somewhere. So the
> >>  authoritative docs stay in the tree, in english, so that as many
> >>  contributors as possible can read and update them. It would then be a
> >>  seperate project to generate translations and keep them updated
> >>  according to what's in the tree.  Perhaps we could get the kernel.org
> >>  people to create an official space for that and then place a pointer
> >>  to that site in Documentation/ somewhere.
> > No, I think the translated files should be in the tree proper, we have
> > the space :)
> 
>  Frankly i don't see the difference between this and the annual reoccurring 
>  "why can't the kernel messages be localized" discussion.
>  (Which is a little overdue, but maybe this replaces it this time.)

It is _vastly_ different.

>  I could see the point in ONE "HOWTO" file per language to get people 
>  started, but everything else is a pointless exercise.
>  A developer/bug-reporter has to be able to express him-/herself in English 
>  and understand English, otherwise you can not accomplish very much.

Yes, but this file, and the stable-api-nonsense.txt files are there to
help people understand both the kernel's philosophy, as well as
encourage them to help contribute.

That is totally different from internationalizing the internal kernel
messages (which, btw, some people are working on...)  That I would not
agree to as it's just too hard to keep up with and would be pointless in
a way.

So I really do want to see a translated copy of the HOWTO,
stable-api-nonsense.txt, and possibly a few other files in the main
kernel tree (SubmittingPatches, CodingStyle, and SubmittingDrivers might
all be good canidates for this.)  These files change relativly
infrequently (the HOWTO file has had only 7 changes in 1 and 1/2 years,
and they were very minor ones) and should be easy for the translators to
keep up with.

So, Tsugikazu, care to resend this file as a patch that I can apply to
the Documentation directory of the kernel tree?  I think it would be
good to have there.

thanks,

greg k-h
