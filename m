Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYJXWY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYJXWY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYJXWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:24:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbYJXWYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:24:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: oops while booting with recent git kernel
Date: Sat, 25 Oct 2008 00:29:35 +0200
User-Agent: KMail/1.9.9
Cc: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
References: <200810121227.09114.a.miskiewicz@gmail.com> <19f34abd0810132130r524c252q3fb5c520c34cf51@mail.gmail.com>
In-Reply-To: <19f34abd0810132130r524c252q3fb5c520c34cf51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250029.35880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 of October 2008, Vegard Nossum wrote:
> On Sun, Oct 12, 2008 at 12:27 PM, Arkadiusz Miskiewicz
> <a.miskiewicz@gmail.com> wrote:
> >
> > Not sure if it's worth to report this before all initial merges happen but
> > here it is anyway.
> >
> > git kernel with latest commit:
> > commit fd048088306656824958e7783ffcee27e241b361
> > Date:   Sat Oct 11 13:23:48 2008 -0700
> >
> > booted on thinkpad z60m results with such oops:
> > http://carme.pld-linux.org/~arekm/img_2325_small.png
> >
> > Config used:
> > http://carme.pld-linux.org/~arekm/img_2325_small.config
> 
> Thanks for the report.
> 
> It seems to be an instance of this (known bad) code:
> http://lkml.org/lkml/2008/9/4/386
> 
> So hopefully it will be fixed soon.

Has it been fixed, actually?

Rafael
