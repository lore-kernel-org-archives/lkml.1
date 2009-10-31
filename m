Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZJaHuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZJaHuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 03:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZJaHuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 03:50:46 -0400
Received: from www84.your-server.de ([213.133.104.84]:48270 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZJaHup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 03:50:45 -0400
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20091030222447.GA11671@kroah.com>
References: <1256391194.7362.7.camel@wall-e>
	 <20091030222447.GA11671@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 31 Oct 2009 08:50:40 +0100
Message-ID: <1256975440.32191.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for your support. But i don't think so. The current patch should
fix all drivers which are use the old kfifo. If there are problems i
will contact you ;-)

Greetings,
Stefani
 
Am Freitag, den 30.10.2009, 15:24 -0700 schrieb Greg KH:
> On Sat, Oct 24, 2009 at 03:33:14PM +0200, Stefani Seibold wrote:
> > This is a new generic kernel FIFO implementation.
> 
> <snip>
> 
> Good stuff, how is this going to get into Linus's tree for .33?  Need me
> to take it through the "driver core" tree, as it seems to touch a lot of
> drivers?  If so, I'll be glad to do so.
> 
> Feel free to add my:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patches touching the USB files.
> 
> thanks,
> 
> greg k-h


