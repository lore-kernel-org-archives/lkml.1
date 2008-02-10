Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYBJFoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYBJFoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 00:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYBJFnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 00:43:50 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41005 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYBJFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 00:43:49 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: davids@webmaster.com, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200802100007.50441.dhazelton@enter.net>
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
	 <1202619017.7664.53.camel@violet>  <200802100007.50441.dhazelton@enter.net>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 06:43:49 +0100
Message-Id: <1202622229.7664.65.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> > > > It makes no difference if you
> > > > distribute the GPL library with it or not.
> > >
> > > If you do not distribute the GPL library, the library is simply being
> > > used in the intended, ordinary way. You do not need to agree to, nor can
> > > you violate, the GPL simply by using a work in its ordinary intended way.
> > >
> > > If the application contains insufficient copyrightable expression from
> > > the library to be considered a derivative work (and purely functional
> > > things do not count), then it cannot be a derivative work. The library is
> > > not being copied or distributed. So how can its copyright be infringed?
> >
> > go ahead and create an application that uses a GPL only library. Then
> > ask a lawyer if it is okay to distribute your application in binary only
> > form without making the source code available (according to the GPL).
> >
> > http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#IfLibraryIsGPL
> >
> > http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#LinkingWithGPL
>
> In the US, at least, the belief that "Linking", in *ANY* form, with a GPL 
> library creates a derivative work, is fallacious.

that is how FSF states it and it seems that most legal departments of
big companies (US and EU based) are not taking any risk on this. So it
seems that someone actually has to prove in court that these assumptions
for the GPL case are wrong.

> Were I to create an 
> application that uses, say, GTK for the interface the protected expression is 
> my "unique and creative" use of the GTK API for creating the specific 
> interface and any other code I have written using the API. I hold sole 
> license to the copyright on that code and am able to license said code under 
> the specific license of my choice.

Not even getting into this one since GTK+ is a LGPL based library. Get
your examples straight.

> Why? Because the pre-processor is what is including any GPL'd code in my 
> application and expanding any macros. That is a purely mechanical process and 
> hence the output is not able to be separately copyrighted - if it could be, 
> then the copyright would be held by the *COMPILER*, and I am *NOT* bound by 
> the license on that code. The same applies if GPL'd code is included in my 
> application during the linking process. QED: The "Linking" argument used by 
> most people is wholly fallacious in at least one major country - and if I'm 
> not mistaken, the output from an automated process is similarly not 
> considered as carrying a separate copyright in all nations that are 
> signatories of or follow the Bern Convention.

The GPL is a license. Nobody is talking about the copyright of your code
here. You always have the copyright on your code. The point is that you
have to license your code under GPL (when using a GPL library) and you
are distributing your code.

Regards

Marcel


