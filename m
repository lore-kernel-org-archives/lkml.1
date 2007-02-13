Return-Path: <linux-kernel-owner+w=401wt.eu-S1751204AbXBMR2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbXBMR2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXBMR2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:28:39 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32954 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbXBMR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:28:38 -0500
X-Sasl-enc: xGtINyykSJR9seBSV2aUgUTNnVkxMN6rIpn0hnJ5b1SQ 1171387715
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs
	protocol somewhere
From: Ian Kent <raven@themaw.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <45D1C61F.9090509@redhat.com>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
	 <1170901990.3383.18.camel@raven.themaw.net>
	 <1171262594.18376.13.camel@raven.themaw.net>
	 <20070212135749.GA1681@dspnet.fr.eu.org>
	 <1171327959.3377.3.camel@raven.themaw.net>
	 <20070213085053.GA74257@dspnet.fr.eu.org>  <45D1C61F.9090509@redhat.com>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 02:29:18 +0900
Message-Id: <1171387758.3377.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 09:07 -0500, Chuck Ebbert wrote:
> Olivier Galibert wrote:
> > On Tue, Feb 13, 2007 at 09:52:39AM +0900, Ian Kent wrote:
> >> Indeed.
> >> Which kernel can you use?
> >> I believe that 2200 had another problem so can you use an fc5 kernel
> >> later than that?
> > 
> > I've ported your patch to 2257 (nothing special, only moved lines),
> > and it seems to work beautifully.  I'm enlarging the testing.
> > 
> 
> If you get the patches into -stable they will end up in Fedora
> kernels automatically. 2288 (based on 2.6.19) is in testing now...

This has just been done.
I'll be submitting the new patches soon, if all goes well.

Ian


