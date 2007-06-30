Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbXF3Vjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbXF3Vjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXF3Vjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:39:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbXF3Vji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:39:38 -0400
Date: Sat, 30 Jun 2007 14:39:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070630143914.029ce2a7.akpm@linux-foundation.org>
In-Reply-To: <20070630211017.GA26234@uranus.ravnborg.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<6150.1183128630@turing-police.cc.vt.edu>
	<20070629140130.59d58c44.akpm@linux-foundation.org>
	<15437.1183177066@turing-police.cc.vt.edu>
	<20070629221510.95c4c8e1.akpm@linux-foundation.org>
	<20070630211017.GA26234@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 23:10:17 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> > I continue to believe that kbuild's lets-trash-your-symlink behaviour is
> > obnoxious, but I was unable to persuade anyone else of this.
> 
> I thought we fixed that long time ago?!?!

Nope, a simple `make oldconfig' breaks the symlink.

> I am heading for vacation for 20 days without Internet (real vacation :-))

Can I come?

> and have properly forget most about Linux and everything about this
> issue when I return.
> In the unlikely event that I recall it I will take a look when I'm back.
> 
> By the way - kbuild.git is lacking behind on patches.
> I have several queded from other peopel and have more in the works myself.
> This will not be looked into until I'm back.

No probs - it's been like that for all time.
