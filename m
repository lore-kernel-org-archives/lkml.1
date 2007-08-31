Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXHaJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXHaJvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbXHaJvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:51:31 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35768 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXHaJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:51:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: possible build system oddity
Date: Fri, 31 Aug 2007 11:51:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
References: <200708311037.29280.oliver@neukum.org> <b6fcc0a0708310214u64af62cfv23893a503a166f82@mail.gmail.com> <20070831094757.GA24995@uranus.ravnborg.org>
In-Reply-To: <20070831094757.GA24995@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311151.32618.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 31 August 2007 schrieb Sam Ravnborg:
> On Fri, Aug 31, 2007 at 01:14:26PM +0400, Alexey Dobriyan wrote:
> > On 8/31/07, Oliver Neukum <oliver@neukum.org> wrote:
> > > I only touched sound/usb/usbaudio.c
> > > Nevertheless the whole subtree und sound/ is recompiling. What's
> > > happening?
> > 
> > Not here. Do make V=2, it should say why it's recompiling.
> 
> And if the problem persist then do a make V=1 and post output here.
> This information combined should tell what goes wrong.

Not reproducible. Sorry.

	Regards
		Oliver

