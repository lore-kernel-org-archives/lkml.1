Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYAIJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYAIJTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYAIJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:18:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:50414 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYAIJSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S+gIOQR5sXHa19XkeH8jz63B03Yv4kSJEHoGXPdY+nLTaoHSSZzFX/CxvRxJTZzJ0BWR6sSensn7JnaVzmcAdwQb9JTEox+YVLod3QS50K42KoCnFYGfyw/NtkCT0untAHGxW0WlTqO4Ln39inUQjao2aKkKjsT4ssr+agl2n4Y=
Message-ID: <661de9470801090118y5304dab6y58592ff8dd2759b6@mail.gmail.com>
Date: Wed, 9 Jan 2008 14:48:40 +0530
From: "Balbir Singh" <bsingharora@gmail.com>
To: subrata@linux.vnet.ibm.com
Subject: Re: [LTP] Container Code Coverage for 2.6.23 mainline kernel
Cc: risrajak@in.ibm.com, ltp-announce@lists.sourceforge.net,
       ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, lxc-dev@googlegroups.com
In-Reply-To: <1199870159.4415.24.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199863373.4440.9.camel@localhost.localdomain>
	 <661de9470801090108k2e81e8fawf885d643b0aeeafe@mail.gmail.com>
	 <1199870159.4415.24.camel@subratamodak.linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 2:45 PM, Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
>
> On Wed, 2008-01-09 at 14:38 +0530, Balbir Singh wrote:
> > On Jan 9, 2008 12:52 PM, Rishikesh K. Rajak <risrajak@linux.vnet.ibm.com> wrote:
> > >
> > >  Hi All,
> > >
> > >  You can find the code coverage data for container code which has been
> > > merged with mainline linux-2.6.23 and respective testcases are merged with
> > > ltp for the feature called SYSVIPC NAMESPACE & UTS NAMESPACE .
> > >
> > >  I have genrated the code on s390x machine, the more info you can find
> > > below.
> > >
> > >  Linux  2.6.23-gcov-autokern1 #1 SMP Wed Jan 9 00:27:11 EST 2008 s390x s390x
> > > s390x GNU/Linux
> > >
> > >  Please let me know if you need more info.
> > >
> > >  Thanks
> > >  Rishi
> > >
> >
> > Rishi,
> >
> > Something is wrong with the HTML within the tarball, it still points
> > to files in /home/rishi/....
> > Could you please fix that.
>
> Balbir, this HTML is just a saved as version of the original HTML as
> Rishi cannot TAR and send the original HTML file as it has to refer to
> hundreds of other files, which in that case will be difficult to Pack
> and send to the mailing list. So, he has saved the original HTML and
> then posted just that.
>
> --Subrata
>
> >
> > Thanks,
> > Balbir

Subrata,

These files or their data is required to interpret the coverage data.
Details for each file and lines covered will help developers or
testers know what is not covered by these test cases.

Balbir
