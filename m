Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYBJEua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYBJEua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 23:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYBJEuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 23:50:20 -0500
Received: from senator.holtmann.net ([87.106.208.187]:34439 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYBJEuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 23:50:18 -0500
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: davids@webmaster.com
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 05:50:17 +0100
Message-Id: <1202619017.7664.53.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > Lets phrase this in better words as Valdis pointed out: You can't
> > distribute an application (binary or source form) under anything else
> > than GPL if it uses a GPL library.
> 
> This simply cannot be correct. The only way it could be true is if the work
> was a derivative work of a GPL'd work. There is no other way it could become
> subject to the GPL.
> 
> So this argument reduces to -- any work that uses a library is a derivative
> work of that library. But this is clearly wrong. For work X to be a
> derivative work of work Y, it must contain substantial protected expression
> from work Y, but an application need not have any expression from the
> libraries it uses.
> 
> > It makes no difference if you
> > distribute the GPL library with it or not.
> 
> If you do not distribute the GPL library, the library is simply being used
> in the intended, ordinary way. You do not need to agree to, nor can you
> violate, the GPL simply by using a work in its ordinary intended way.
> 
> If the application contains insufficient copyrightable expression from the
> library to be considered a derivative work (and purely functional things do
> not count), then it cannot be a derivative work. The library is not being
> copied or distributed. So how can its copyright be infringed?

go ahead and create an application that uses a GPL only library. Then
ask a lawyer if it is okay to distribute your application in binary only
form without making the source code available (according to the GPL).

http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#IfLibraryIsGPL

http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#LinkingWithGPL

Regards

Marcel


