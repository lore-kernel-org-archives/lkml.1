Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYDUOZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYDUOZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbYDUOZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:25:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:22323 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbYDUOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r89D9XkhSslXVxOUgqzNPqagy29Erg1KAE3/E+SpbeDIg7uN0xTReSEQ6m4L72LQ1cvwJrAoONX9oJb0DJXIYRODLQsfBwAXuAuMwq79AHIPlEn4ETnGoOZevrvnqbCVaB9jqsr80pBGyzjv0T10TGnVLJBwkxxM0Hd0S+HjyfQ=
Message-ID: <b6a2187b0804210724t5c54d5b0p79b55ae0c989c8ca@mail.gmail.com>
Date: Mon, 21 Apr 2008 22:24:58 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] fix asm-x86/{posix_types,unistd}.h
Cc: "Joe Perches" <joe@perches.com>, "Ingo Molnar" <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080420190217.GA14788@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804192351220.3260@boston.corp.fedex.com>
	 <20080420190217.GA14788@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 3:02 AM, Adrian Bunk <bunk@kernel.org> wrote:

>  This doesn't look as if it will work with 64bit userspace.

I forgot about that. Sorry, still on 32-bit.

Thanks,
Jeff.
