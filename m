Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbYCVAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbYCVAN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYCVANs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:13:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44372
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYCVANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:13:47 -0400
Date: Fri, 21 Mar 2008 17:14:01 -0700 (PDT)
Message-Id: <20080321.171401.49157146.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
From: David Miller <davem@davemloft.net>
In-Reply-To: <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
References: <20080321224250.144333319@sous-sol.org>
	<20080321224333.400857992@sous-sol.org>
	<9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Sat, 22 Mar 2008 01:10:40 +0100

> As I see it, this patch is quite trivial and does not fix any "real problem".
> How come this is suitable for -stable?
> 
> I have no objections to the patch "as such", I just don't think it
> makes sense for -stable.

It makes a difference for driver maintainers when users
report bugs and we ask them for the version printed
by the driver so that we know which fixes have been
applied.

You know, if people are going to be jerky about this,
I'll just include the version bump in the actual bug
fixes which I sometimes do anyways.

Thanks for bringing this up, it's a useful use of
everyone's time :-/
