Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbXHIV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbXHIV5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXHIV5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:57:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbXHIV5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:57:24 -0400
Date: Thu, 9 Aug 2007 14:56:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aaron Durbin" <adurbin@google.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, "Robin Holt" <holt@sgi.com>
Subject: Re: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in
 setup_APIC_timer
Message-Id: <20070809145641.dc9f8890.akpm@linux-foundation.org>
In-Reply-To: <8f95bb250708091416w5fd4981ds667164d1c9fe9296@mail.gmail.com>
References: <20070808231719.GA7101@google.com>
	<20070809133011.2d03c04a.akpm@linux-foundation.org>
	<8f95bb250708091416w5fd4981ds667164d1c9fe9296@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 14:16:16 -0700
"Aaron Durbin" <adurbin@google.com> wrote:

> > but, but.  Didn't this get fixed by
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm1/broken-out/fix-hpet-init-race.patch
> > ?
> >
> 
> That original patch looks good to me as well. I just checked git head to see if
> this was already fixed upstream, and it didn't appear to be. Sorry for the
> duplicate patch.

Yeah, sorry, I'm being a bit more batch-oriented in getting stuff into
Linus nowadays.  I seem to have 44 patches to go and another 20 which 
should go, but which belong to subsystem maintainers.  We'll get there.
