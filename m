Return-Path: <linux-kernel-owner+w=401wt.eu-S2992976AbXDDP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992976AbXDDP7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992977AbXDDP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:59:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33678 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992976AbXDDP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:59:40 -0400
Date: Wed, 4 Apr 2007 17:00:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404170016.453d26f1@the-village.bc.nu>
In-Reply-To: <4613C963.6070409@gmail.com>
References: <46138B4C.2050409@gmail.com>
	<20070404123311.GA18552@infradead.org>
	<1175698135.5815.447.camel@violet>
	<20070404150231.GE27660@stusta.de>
	<4613C963.6070409@gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Given that people seem to agree that authorship information has no place 
> in the binary, that might actually be best.

Authorship information is very useful in the binary, especially when you
have to get lawyers involved in explaining things to people. Company
business and management people understand

"load it into a binary editor, search for Alan Cox, now call your lawyer"

trying to prove a given source is a given binary is much much harder.

> So, MODULE_AUTHOR be gone?

Not if I have anything to do with it. Putting maintainer in is not a bad
idea but that assumes it gets maintained, the beauty of _AUTHOR is that
it's generally right and stays that way or approximately so.

Alan
