Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXJQXUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXJQXUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbXJQXTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:19:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:37187 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXJQXTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iWTBPdFQTKA+nnbyUjufzF8nuYCNfFjEnwAVqTtzD3tX4lTzJARDYXU4jpqI333WUOi63JU94MOA7Jy1QwkFC04NZfjGAZoFG3Wi3E853PP11pCCOGipvsV5FOcmb55y4gSrnpZlDuD7Ta9hbunmPa6lNpy0Y03l/MJqXc8KOPs=
Message-ID: <a4e6962a0710171619r60bea067u5255657381b2d0a9@mail.gmail.com>
Date: Wed, 17 Oct 2007 18:19:53 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [GIT PULL] 9p patches for 2.6.24 merge window
Cc: torvalds@osdl.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
In-Reply-To: <20071017213906.GB13250@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0710171434l5ff6cecfib1e8b231b8b610b6@mail.gmail.com>
	 <20071017213906.GB13250@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Oct 17, 2007 at 04:34:02PM -0500, Eric Van Hensbergen wrote:
> > Linus, please pull from the 'for-linus' branch of:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus
> >
> > This tree contains the following:
> >
> > Latchesar Ionkov(3):
> >   attach-per-user support
> >   rename uid and gid parameters
> >   define session flags
> >
> > Eric Van Hensbergen(4)
> >   remove sysctl code
> >   fix bad kconfig cross-dependency
> >   soften invalidationin loose mode
> >   make transports dynamic
>
> Could you please tag your patches with 9p: or [9p] so it
> is obvious that they belong to this subsystem.
> When browsing head-commits and other places this is a great help.
>

They should be so tagged, I just stripped it in my pull email summary.

           -eric
