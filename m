Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYJWJRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYJWJRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYJWJRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:17:22 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:11020
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYJWJRV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:17:21 -0400
X-Trace: 151369575/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAHjd/0jDlSwG/2dsb2JhbACBdr5Lg04
X-IronPort-AV: E=Sophos;i="4.33,469,1220223600"; 
   d="scan'208";a="151369575"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
Date: Thu, 23 Oct 2008 10:17:15 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-damocles; KDE/4.1.2; x86_64; ; )
Cc: Robert Moss <robert.von.moss@gmail.com>, linux-kernel@vger.kernel.org
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com> <20081023080459.GC5073@const.bordeaux.inria.fr>
In-Reply-To: <20081023080459.GC5073@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810231017.16126.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 09:04:59 Samuel Thibault wrote:
> Robert Moss, le Thu 23 Oct 2008 00:54:56 -0700, a écrit :
> > Anyhow, I noticed that vesafb is no longer a part of the kernel.
>
> That's not true. It works nicely on my laptop (though I don't get
> the native 1280x800 resolution).
>
> > vga=791 still gave a mode not found.
>
> Then that's a bug, which is a completely different thing. Could you
> check that the output of vga=ask and typing scan at the boot prompt is
> the same between 2.6.24 and 2.6.25/26 ?

It simply isn't true that the vesafb driver has been removed or disabled. Nor 
is it true that the vga= video mode selection has been removed or is broken.

I've been using vga=791, too, for years, and on 2.6.26 and 2.6.27 it continues 
to work as it always did.

The OP needs to post his config before creating a fuss about removed features 
and "lack of choice". From what I can see, such statements simply aren't true.

At worst there is a bug here on one particular system that needs to be fixed.

-- 
Cheers,
Alistair.
