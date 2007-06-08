Return-Path: <linux-kernel-owner+w=401wt.eu-S967125AbXFHCHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967125AbXFHCHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764091AbXFHCHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:07:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55608 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152AbXFHCHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:07:34 -0400
Date: Thu, 7 Jun 2007 22:07:30 -0400
From: Jeff Garzik <jeff@garzik.org>
To: John Stoffel <john@stoffel.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Message-ID: <20070608020730.GD23290@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu> <m3wsyfzcpt.fsf@maximus.localdomain> <18024.46233.432086.424311@stoffel.org> <20070608014719.GC23290@havoc.gtf.org> <18024.46902.682920.924521@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18024.46902.682920.924521@stoffel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 09:56:06PM -0400, John Stoffel wrote:
> Thinking about it more, I wonder if Krysztof is bitching more about
> the tab width of 8 characters?   I know that it ticks me off,

Even if he is, _that_ is definitely not getting changed.

That was the very first item Linus wrote in Documentation/CodingStyle,
and for good reasons.

If code starts creeping way right due to indentation levels, create a
new function.

	Jeff



