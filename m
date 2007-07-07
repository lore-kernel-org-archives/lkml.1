Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbXGGSib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbXGGSib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXGGShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:37:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbXGGSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:36:57 -0400
Date: Sat, 7 Jul 2007 11:36:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Woodhouse <dwmw2@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
In-Reply-To: <1183832913.6351.130.camel@aeonflux.holtmann.net>
Message-ID: <alpine.LFD.0.999.0707071135090.31544@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com> 
 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com> 
 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>  <200707062033.18211.dtor@insightbb.com>
  <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz> 
 <1183771730.2789.1.camel@shinybook.infradead.org> 
 <1183775126.3066.5.camel@shinybook.infradead.org>
 <1183832913.6351.130.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jul 2007, Marcel Holtmann wrote:
>
> > Marcel? Can we deregister the input devices earlier...?
> 
> looks good to me.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

David, can you add an explanation about the thing (and your sign-off too),
and I can apply it and get this issue out of the way?

		Linus
