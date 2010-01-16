Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0APQY3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099Ab0APQY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:24:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56015 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998Ab0APQY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:24:27 -0500
Date: Sat, 16 Jan 2010 16:27:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by 
 default
Message-ID: <20100116162708.2cdf996e@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2511001160751g2357bf2en2bfacaabe5c2f7e@mail.gmail.com>
References: <1263505677.2074.2.camel@yio.site>
	<20100115065638.005ac690@infradead.org>
	<20100115180341.GA12146@kroah.com>
	<20100115205722.3580b6bf@lxorguk.ukuu.org.uk>
	<ac3eb2511001160751g2357bf2en2bfacaabe5c2f7e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 16:51:23 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Jan 15, 2010 at 21:57, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Why?  All major distros need this at boot time, and as we have been
> >
> > No they don't.
> >
> > Centos doesn't (in fact I suspect it'll break)
> > Fedora 11 doesn't
> > Fedora 12 doesn't seem to (but seems to be willing to use it)
> > Ditto all the older SuSE, Ubuntu etc releases that are *still*
> > active/supported/maintained
> 
> Fedora, SUSE, Ubuntu, ... All releases currently in development enable
> and use it.

Yes - in future your statement may become true (or devtmpfs get obsoleted
by the next best thing.  Thats why it needs to be documented if it is set
that way - I've no problem with it being set that way at all.
