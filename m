Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbXJaT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbXJaT5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXJaT5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:57:13 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:46434 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbXJaT5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:57:13 -0400
Date: Wed, 31 Oct 2007 20:55:58 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Roopesh <roopesh@cyberspace.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MMC: CRC Errors with 2GB cards
Message-ID: <20071031205558.4507a2f0@poseidon.drzeus.cx>
In-Reply-To: <20071029095015.GA20714@grex.cyberspace.org>
References: <20071019161700.GA19254@grex.cyberspace.org>
	<20071027140017.41e9d67f@poseidon.drzeus.cx>
	<20071029095015.GA20714@grex.cyberspace.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 05:50:15 -0400
Roopesh <roopesh@cyberspace.org> wrote:

> 
>  I have purchased 4 Transcend cards, and all of them behave the 
>  same way.  Just wondering why others dont have this problem, and 
>  why such a fix hasn't made it to main tree yet.
> 

Odd. I have a whole bunch of transcend cards, and I've never gotten this problem. Perhaps yours are rather recent?

>  I have tried the fix, and it works fine.  Thanks.
> 

Great. I'll queue it up for -mm for some more testing, after which it will get merged.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
