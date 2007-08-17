Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXHQE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXHQE1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXHQE1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:27:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:14503 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXHQE1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jWxABlPY0UrGoJMzKDcISHf7nU0anAcs3b3C5DlbRbPTeRn1kIYYQeEF/wHbAjSfAQb+nef2xC1Pm5/a8jl9JaoqOrZtxEoR3RQcjWHmFFenHk35Dl1LT7/M2fvIIPEbCV8tpfeqPCiR6l/vIX0iy0/42CYLT8YcfKtCtVkNfXE=
Message-ID: <653402b90708162127x7886b9eclf8e834df3b1adf5c@mail.gmail.com>
Date: Fri, 17 Aug 2007 06:27:02 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187272507.5906.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
	 <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
	 <1187272507.5906.80.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Joe Perches <joe@perches.com> wrote:
> On Thu, 2007-08-16 at 11:16 +0200, Miguel Ojeda wrote:
> > I think you could add also:
> >  +F:     Documentation/auxdisplay/cfag12864bfb
>
> This is what I have now:
>
> CFAG12864BFB LCD FRAMEBUFFER DRIVER
> P:      Miguel Ojeda Sandonis
> M:      maxextreme@gmail.com
> L:      linux-kernel@vger.kernel.org
> W:      http://auxdisplay.googlepages.com/
> S:      Maintained
> F:      Documentation/auxdisplay/cfag12864bfb
> F:      drivers/auxdisplay/cfag12864bfb.c
> F:      include/linux/cfag12864b.h
>
> Joe
>
>

Fine, thank you for the patch!

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
