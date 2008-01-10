Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYAJWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYAJWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAJWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:47:12 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:53088 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYAJWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p11etGkhDPH5zPFPslLBRIJtjcuN43B3Yq5vVOwCsrQPnoghw5wtWtiI/bgCQp2KdAFrh1LXNvAh1SVyMHmcPjZU+9Qgyi0HsvQeKFULauZfwVqFaeff+mOZQlfMVsgeRfF3Ulck2QWR8hTmcZ4HJp17ZsMBqt9wh/P4A82RikA=
Message-ID: <4d8e3fd30801101447p699a61a1q802fdb769c2b9a71@mail.gmail.com>
Date: Thu, 10 Jan 2008 23:47:08 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [x86] list of style offenders
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1200004873.29897.40.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
	 <1200004873.29897.40.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 11:41 PM, Daniel Walker <dwalker@mvista.com> wrote:
>
> On Thu, 2008-01-10 at 23:35 +0100, Paolo Ciarrocchi wrote:
> > On Jan 10, 2008 9:03 PM, Daniel Walker <dwalker@mvista.com> wrote:
> > >
> > >
> > > I was playing with checkpatch.pl ;) .. I made a list of style offenders
> > > inside the arch/x86/ sub-directory. I thought it might be helpful to
> > > prioritize any style clean ups that people might want to do for x86 ..
> > > OTOH some of these might show imperfections in checkpatch.pl .. Either
> > > way I thought it was interesting to review ..
> > >
> > > These are sorted by errors, then warnings.. I only included the first
> > > hundred files which includes about the top %30 of the list .. The
> > > kprobes_64.c error rate is a little miss-leading because several errors
> > > are found on a single line ..
> >
> > I just pulled
> > git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86 mm
> >
> > > ./arch/x86/math-emu/fpu_trig.c
> > >                 total: 649 errors, 11 warnings, 1845 lines checked
>
> Ok, looks like people have been busy .. I was using Linus's git, which
> was handy at the time I ran the test ..

Do you have a script aroung checkpatch.pl for collecting the statistics
you posted? If so, I can run it agains the x86 git tree and report the output.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
