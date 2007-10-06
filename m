Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXJFALE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXJFALE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXJFAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:10:54 -0400
Received: from khc.piap.pl ([195.187.100.11]:51782 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbXJFAKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:10:54 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
	<m3r6k9xi2d.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0710060137520.21791@fbirervta.pbzchgretzou.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 06 Oct 2007 02:10:52 +0200
In-Reply-To: <Pine.LNX.4.64.0710060137520.21791@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Sat, 6 Oct 2007 01:47:25 +0200 (CEST)")
Message-ID: <m3myuxxfub.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

>>I wonder how accurate is it.
>
> Since I do not use 512-glyph fonts, I do not know.

Actually I meant "how accurate my remarks are" :-)

Not convinced WRT ASCII color codes, though. ASCII doesn't contain
codes for changing colors. Perhaps some specific "extended ASCII"?
-- 
Krzysztof Halasa
