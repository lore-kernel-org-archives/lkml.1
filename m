Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbXKLMHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbXKLMHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXKLMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:06:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXKLMGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:06:52 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, axboe@kernel.dk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Include header required for INT_MAX
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
	<jeabpj3fn1.fsf@sykes.suse.de>
	<alpine.LFD.0.9999.0711120551380.23072@localhost.localdomain>
X-Yow: Inside, I'm already SOBBING!
Date: Mon, 12 Nov 2007 13:06:50 +0100
In-Reply-To: <alpine.LFD.0.9999.0711120551380.23072@localhost.localdomain>
	(Robert P. J. Day's message of "Mon\, 12 Nov 2007 05\:51\:54 -0500
	\(EST\)")
Message-ID: <je1wav3bxh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

> On Mon, 12 Nov 2007, Andreas Schwab wrote:
>
>> Jan Engelhardt <jengelh@computergmbh.de> writes:
>>
>> > No, because I be damn sure that some developers try compiling programs
>> > in non-linux environments (cygwin, solaris, andyourpersonaldistro, you
>> > name it) which do not have to adhere to <limits.h>. It might use
>> > <cosmiclimits.h> instead, or whatever.
>>
>> Every C compiler has <limit.h>.
>
> i'm assuming you mean <limits.h>, no?

Yes, sorry for the typo.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
