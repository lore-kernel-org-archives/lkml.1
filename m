Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbXJEXXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbXJEXXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXJEXWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:22:53 -0400
Received: from khc.piap.pl ([195.187.100.11]:46518 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXJEXWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:22:53 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 06 Oct 2007 01:22:50 +0200
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Fri, 5 Oct 2007 21:13:40 +0200 (CEST)")
Message-ID: <m3r6k9xi2d.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> +	The value you need to enter here is the ASCII color value

ASCII color value? ANSI perhaps?

> +	composed (OR'ed) by one foreground color, one background
> +	color and any number of attributes as follows:

I'm certainly not a native English writer, though I think it
should be "composed of" or maybe "composed from".

"one" doesn't sound well in my ears, either.

> +	Using "highlight foreground" is said not work when you use

I'd say "HF is known not to work with VGA console" or just
"HF doesn't work with VGA console".


I wonder how accurate is it.
-- 
Krzysztof Halasa
