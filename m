Return-Path: <linux-kernel-owner+w=401wt.eu-S939098AbXG3TeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939098AbXG3TeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934520AbXG3TeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:34:12 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:5340 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763076AbXG3TeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cdxEnZIn7vfgzIyvNNLXi3e1IqgUjzV99PuuERLbezSAJSRfh7uzNceDDqUv2/wHLQJQSxojxtXr2u9E0zr9R7yIL/NDSLHK7epeEEPQ+Sr/yLeFa5mmZ9VSZOIwvkUWQUHoqWOvkKHvUg6Y/0h7lp9VdX6dwLyKY1YZ3l3jUK4=
Message-ID: <8bd0f97a0707301234y59fef765ke72490298fc94454@mail.gmail.com>
Date: Mon, 30 Jul 2007 15:34:07 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] Remove fs.h from mm.h
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
In-Reply-To: <20070730185445.GA5776@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
	 <20070730185445.GA5776@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Jul 29, 2007 at 05:08:20PM -0700, Linus Torvalds wrote:
> > On Mon, 30 Jul 2007, Alexey Dobriyan wrote:
> > >
> > > Cross-compile tested without regressions on my two usual configs and (sigh):
> > >
> > > alpha              arm-mx1ads        mips-bigsur          powerpc-ebony
> > ..
> >
> > Heh.
> >
> > Kudos for going above and beyond.
> >
> >       "But where is blackfin and frv?"
>
> Actually frv was tested (and patched), just not glued to cross-build
> setup, so I forgot to mention it. As for blackfin, ehh, umm, toolchain
> issues...

what sort of issues ?
-mike
