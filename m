Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbXHaJqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbXHaJqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbXHaJqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:46:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39578 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbXHaJqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:46:36 -0400
Date: Fri, 31 Aug 2007 11:47:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
Message-ID: <20070831094757.GA24995@uranus.ravnborg.org>
References: <200708311037.29280.oliver@neukum.org> <b6fcc0a0708310214u64af62cfv23893a503a166f82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0708310214u64af62cfv23893a503a166f82@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 01:14:26PM +0400, Alexey Dobriyan wrote:
> On 8/31/07, Oliver Neukum <oliver@neukum.org> wrote:
> > I only touched sound/usb/usbaudio.c
> > Nevertheless the whole subtree und sound/ is recompiling. What's
> > happening?
> 
> Not here. Do make V=2, it should say why it's recompiling.

And if the problem persist then do a make V=1 and post output here.
This information combined should tell what goes wrong.

	Sam
