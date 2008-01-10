Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYAJWm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYAJWm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYAJWmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:42:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:4823 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYAJWmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:42:52 -0500
Subject: Re: [x86] list of style offenders
From: Daniel Walker <dwalker@mvista.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 14:41:13 -0800
Message-Id: <1200004873.29897.40.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 23:35 +0100, Paolo Ciarrocchi wrote:
> On Jan 10, 2008 9:03 PM, Daniel Walker <dwalker@mvista.com> wrote:
> >
> >
> > I was playing with checkpatch.pl ;) .. I made a list of style offenders
> > inside the arch/x86/ sub-directory. I thought it might be helpful to
> > prioritize any style clean ups that people might want to do for x86 ..
> > OTOH some of these might show imperfections in checkpatch.pl .. Either
> > way I thought it was interesting to review ..
> >
> > These are sorted by errors, then warnings.. I only included the first
> > hundred files which includes about the top %30 of the list .. The
> > kprobes_64.c error rate is a little miss-leading because several errors
> > are found on a single line ..
> 
> I just pulled
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86 mm
> 
> > ./arch/x86/math-emu/fpu_trig.c
> >                 total: 649 errors, 11 warnings, 1845 lines checked

Ok, looks like people have been busy .. I was using Linus's git, which
was handy at the time I ran the test ..

Daniel

