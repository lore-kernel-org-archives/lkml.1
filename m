Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYI0TLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYI0TLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYI0TLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:11:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:25142 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYI0TLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=JJu+Hd/ra8vx+ZPX4trR3+bdgcovs/5t/HgphyzgNTteakVWFkOeD1f8jKcWfUdDFI
         ZMoM3j5Qqq0LCaJLrjUSdvZNFoJAV0DFOjWeANuD0UqYoxG4ifm3fGzTsGj45Z17rEcc
         G9O4M1qDHy9j1671pxGl5o6e2qEVTt4pApYcU=
Date: Sat, 27 Sep 2008 21:11:31 +0200
From: dcg <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080927211131.2e0b60f0@diego-desktop>
In-Reply-To: <20080927185027.GB17867@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com>
	<20080925091558.GE16734@elte.hu>
	<20080925161300.GA17162@nostromo.devel.redhat.com>
	<20080927185027.GB17867@elte.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 27 Sep 2008 20:50:27 +0200, Ingo Molnar <mingo@elte.hu> escribió:

> that has some marginal use: it shows that we are past the really basic 
> system setup code, we decompressed the kernel and entered protected mode 
> with boot paging enabled.

What I find annoying about that printk is that I see it even with the "quiet"
boot flag.
