Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0AOUy5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447Ab0AOUy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:54:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46180 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891Ab0AOUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:54:56 -0500
Date: Fri, 15 Jan 2010 20:57:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100115205722.3580b6bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20100115180341.GA12146@kroah.com>
References: <1263505677.2074.2.camel@yio.site>
	<20100115065638.005ac690@infradead.org>
	<20100115180341.GA12146@kroah.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why?  All major distros need this at boot time, and as we have been

No they don't.

Centos doesn't (in fact I suspect it'll break)
Fedora 11 doesn't
Fedora 12 doesn't seem to (but seems to be willing to use it)
Ditto all the older SuSE, Ubuntu etc releases that are *still*
active/supported/maintained


> through a release cycle with the config option, anyone who is
> incrementally updating will continue with their existing value.  But new
> people coming in, will get the option as it is most likely required to
> boot properly.
> 
> Makes sense to me.

That may well be true - in which case it needs to be very clearly
documented when to enable it.
