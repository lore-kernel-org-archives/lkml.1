Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXKLKqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXKLKqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbXKLKqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:46:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:43713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbXKLKqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:46:43 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: axboe@kernel.dk, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Include header required for INT_MAX
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
X-Yow: I'm thinking about DIGITAL READ-OUT systems and
 computer-generated IMAGE FORMATIONS..
Date: Mon, 12 Nov 2007 11:46:42 +0100
In-Reply-To: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Sun\, 11 Nov 2007 23\:52\:24 +0100 \(CET\)")
Message-ID: <jeabpj3fn1.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> No, because I be damn sure that some developers try compiling programs 
> in non-linux environments (cygwin, solaris, andyourpersonaldistro, you 
> name it) which do not have to adhere to <limits.h>. It might use 
> <cosmiclimits.h> instead, or whatever.

Every C compiler has <limit.h>.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
