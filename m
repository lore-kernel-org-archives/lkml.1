Return-Path: <linux-kernel-owner+w=401wt.eu-S2992984AbXDDQGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992984AbXDDQGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992986AbXDDQGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:06:45 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:48610 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992984AbXDDQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:06:42 -0400
Subject: Re: MODULE_MAINTAINER
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rene Herman <rene.herman@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070404170016.453d26f1@the-village.bc.nu>
References: <46138B4C.2050409@gmail.com>
	 <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet>
	 <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com>
	 <20070404170016.453d26f1@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 18:06:09 +0200
Message-Id: <1175702769.5815.489.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > Given that people seem to agree that authorship information has no place 
> > in the binary, that might actually be best.
> 
> Authorship information is very useful in the binary, especially when you
> have to get lawyers involved in explaining things to people. Company
> business and management people understand
> 
> "load it into a binary editor, search for Alan Cox, now call your lawyer"
> 
> trying to prove a given source is a given binary is much much harder.
> 
> > So, MODULE_AUTHOR be gone?
> 
> Not if I have anything to do with it. Putting maintainer in is not a bad
> idea but that assumes it gets maintained, the beauty of _AUTHOR is that
> it's generally right and stays that way or approximately so.

removing the MODULE_AUTHOR is a bad idea. I really like to call modinfo
and see who maintains a specific driver.

Regards

Marcel


