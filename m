Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbXGAGvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbXGAGvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXGAGv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 02:51:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39579 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXGAGv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 02:51:26 -0400
Date: Sun, 1 Jul 2007 08:52:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-ID: <20070701065232.GA16739@uranus.ravnborg.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <6150.1183128630@turing-police.cc.vt.edu> <20070629140130.59d58c44.akpm@linux-foundation.org> <15437.1183177066@turing-police.cc.vt.edu> <20070629221510.95c4c8e1.akpm@linux-foundation.org> <20070630211017.GA26234@uranus.ravnborg.org> <a781481a0706302231g70bd82c9m9d91abae411233ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706302231g70bd82c9m9d91abae411233ee@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 11:01:45AM +0530, Satyam Sharma wrote:
> On 7/1/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> >[...]
> >I am heading for vacation for 20 days without Internet (real vacation :-))
> 
> I hope I'm not late in catching you here ...
> 
> >By the way - kbuild.git is lacking behind on patches.
> >I have several queded from other peopel and have more in the works myself.
> 
> ... is http://lkml.org/lkml/2007/6/23/116/ one of those queued up too?

Nope. I usually does not include section mismatch fixes in the kbuild.git
tree but leave that to the maintainers in the particular areas.

This patch should go in via SH maintainer since this is sh specific
driver(s).

	Sam
