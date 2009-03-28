Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZC1EHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZC1EHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 00:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZC1EHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 00:07:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZC1EHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 00:07:05 -0400
Date: Sat, 28 Mar 2009 01:06:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [git pull] FireWire updates post 2.6.29
Message-ID: <20090328010633.56c10696@pedra.chehab.org>
In-Reply-To: <tkrat.09e279b9fad0fd3c@s5r6.in-berlin.de>
References: <tkrat.09e279b9fad0fd3c@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 01:11:20 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following IEEE 1394/ FireWire subsystem updates.
> Most of it are feature additions to firewire-core for userspace drivers
> (via libdc1394 and libraw1394), some also for in-kernel drivers.  Much
> of it has been written already last year and went into -next early this
> year, slightly too late for 2.6.29. Userspace code which uses the
> features went over the respective mailinglists and should appear in
> libdc1394 and libraw1394 soon.  Also included:  Two recent dvb/firewire
> fixes; Mauro has been informed.
> 
>  drivers/media/dvb/firewire/firedtv-avc.c |   10 +-

For the V4L/DVB changes:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>



Cheers,
Mauro
