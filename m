Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZEIPtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZEIPtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZEIPtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:49:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZEIPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:49:22 -0400
Date: Sat, 9 May 2009 08:22:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090509082233.32cbb8e4@infradead.org>
In-Reply-To: <20090509150853.GA32394@suse.de>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 08:08:53 -0700
Greg KH <gregkh@suse.de> wrote:

> > Well, guess you meant the opposite ;-)
> 
> Heh, yes, sorry about that.  It makes booting faster :)

.. and I don't buy that.

The only argument I've heard is "oh but it's hard". No it's not.
The other argument is "but for more partitions we get other device
numbers"... you know what, that's easy to fix. Just make the 32 bit dev
number consistent. Few lines of code I bet, and it is benefit for
everyone to do that....

Beyond that... this is not needed... but at least call it "devfs".. for
what it is.

(and yes there is very obvious irony)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
