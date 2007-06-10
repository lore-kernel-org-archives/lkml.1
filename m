Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXFJQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXFJQwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXFJQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:52:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:56572 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXFJQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K7iAjZc2hTSMne3dmahLGlvB/ax21WEaXUsMjffBUNqWQabps9ktbN2VPopCEj3iAF4Lv0IZ6PeDPpzqoZ5d/GO9EnxRM44JnvYy9RrC8BkC4vlPtj4aRtURxT0fmx/In05q6jmepJ5ib3VjlyWPMYozYOoAOfXL7DVdSwEomUo=
Subject: Re: -ck patch | Feedback
From: Celso <celsopr@gmail.com>
To: Miguel Figueiredo <elmig@debianpt.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <466A7321.4060304@debianpt.org>
References: <1181341039.28846.0.camel@localhost>
	 <466A7321.4060304@debianpt.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 10 Jun 2007 17:52:40 +0100
Message-Id: <1181494360.4026.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sáb, 2007-06-09 às 10:30 +0100, Miguel Figueiredo escreveu:
> Celso wrote:
> > Hello, I'm using -ck since... along time ago (I start using it with the
> > kernel 2.6.16) . I started using it with Ubuntu and  the response of the
> > system  was better. Since that I always compile my kernels with -ck.
> > Actually I use 2.6.20-ck1 and I have no problems, even with things that
> > needs kernel-sources like gspca for my webcam.
> > 
> > Thanks a lot for the patches. 
> > 
> > PS: when will this go into the official kernel?
> > 
> 
> Hi there,
> 
>   have you tryied a newer kernel with -ck2 [1] ?
> 
> I am also using a -ck patch, 2.6.21-ck2, mostly on 2 machines where i
> use as desktop and also play games. With -ck2 the experience seems less
> slugish and more smooth while playing 'second life' and have a bunch of
> other programs open (mail, a zillion web pages, irc client, feed reader,
> consoles, ...).
> The desktop seems more confortable to use than with the vanilla kernel.
> I also tryed cfs, it's also much better than the vanilla kernel but i
> still prefer -ck2 for playing second life as it feels more responsive.
> 
> 
> If you try the -ck2 or SD 1.0 please report your experience. It's nice
> to hear that people are testing/using these improvements on desktop usage.
> 
> 
> 
> 1 - ck2 patch to add to vanilla 2.6.21,
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck2/patch-2.6.21-ck2.bz2
> 
> PS: I remember i read somewhere that the SD patch (included in -ck) has
> became stable (version 1.0) with a few small improvements!
> 

Well, I upgrade to 2.6.21-ck2 and install it on my two pcs (I had before
2.6.20-ck1 on both) and the installation work, like always, fine. No
problems. On the pc I use most (the better one :) ) I didn't feel much
difference from 2.6.20-ck1 to 2.6.21-ck2 (for regular Desktop use), but
in the older pc, where my brother works, he says that was even more
"fluid"*.

* direct translation sorry if it doesn't sound well

