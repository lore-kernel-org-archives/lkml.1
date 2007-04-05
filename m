Return-Path: <linux-kernel-owner+w=401wt.eu-S1767368AbXDEWBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767368AbXDEWBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767369AbXDEWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:01:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:56624 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767368AbXDEWBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kmyOV0TdQdDs3n9R3nQNvqzNm3ofI+jdlwwInHjB7s/8Wecn7JgMxqNSlBktEKS1mqCtSZd300c6IrpdUkdLyP0F4lECD5AsivlOlKuL7lrCvXrc47FWhPI4P2EVX6+SBQwCO5quhE3uJyWzP3iTrZ61OaXr0fHpz0rJcYlve+0=
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1175809336.10105.54.camel@jetpack.demon.co.uk>
References: <1175769886.10382.29.camel@localhost>
	 <200704052138.08897.arnd@arndb.de>
	 <1175809336.10105.54.camel@jetpack.demon.co.uk>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 06:00:58 +0800
Message-Id: <1175810458.31131.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 22:42 +0100, Alan Hourihane wrote:
> On Thu, 2007-04-05 at 21:38 +0200, Arnd Bergmann wrote:
> > On Thursday 05 April 2007, Alan Hourihane wrote:
> > > @@ -0,0 +1,405 @@
> > > +/*  
> > > + * Copyright (c) Intel Corp. 2007.
> > > + * All Rights Reserved.
> > > + *
> > 
> > Saying 'All Rights Reserved' is usually considered the opposite of
> > licensing your code as GPL. I suppose you need to remove that.
> 
> Arnd, 
> 
> Thanks for your comments, and I'll review and make appropriate changes
> as you've suggested.
> 
> As for the above, I've noticed that drivers/video/epson1355fb.c also has
> this wording and is under the GPL. 
> 

"All Rights Reserved" is written notice, a part of copyright law
formality. Nowadays, your works are protected (under the copyright law)
even without that written notice, so the phrase can be excluded.

I don't think the phrase is incompatible with GPL.

Tony 



