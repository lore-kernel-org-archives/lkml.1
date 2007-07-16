Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbXGPJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbXGPJbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXGPJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:31:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:58606 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXGPJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:31:04 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __attribute__ in asm-powerpc
References: <200707142336.10343.vapier@gentoo.org>
	<Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be>
X-Yow: ..  Once upon a time, four AMPHIBIOUS HOG CALLERS attacked a family
 of DEFENSELESS, SENSITIVE COIN COLLECTORS and brought DOWN their
 PROPERTY VALUES!!
Date: Mon, 16 Jul 2007 11:30:57 +0200
In-Reply-To: <Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be> (Geert
	Uytterhoeven's message of "Mon\, 16 Jul 2007 11\:18\:36 +0200 \(CEST\)")
Message-ID: <jetzs4bsq6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> writes:

> If the code is not exported to userspace (and thus not subject to different
> compilers), I think the preferred form is plain `attribute'.

That does not exist without underscores.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
