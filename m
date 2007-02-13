Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXBMNkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXBMNkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXBMNkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:40:18 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46674 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932597AbXBMNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:40:17 -0500
X-Sasl-enc: qR3/Izgdla3UYuwL79cAaoRYiRi+lL6tJj9BR7Ix5WJH 1171374014
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs
	protocol somewhere
From: Ian Kent <raven@themaw.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <20070213085053.GA74257@dspnet.fr.eu.org>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
	 <1170901990.3383.18.camel@raven.themaw.net>
	 <1171262594.18376.13.camel@raven.themaw.net>
	 <20070212135749.GA1681@dspnet.fr.eu.org>
	 <1171327959.3377.3.camel@raven.themaw.net>
	 <20070213085053.GA74257@dspnet.fr.eu.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 22:40:56 +0900
Message-Id: <1171374056.3377.16.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 09:50 +0100, Olivier Galibert wrote:
> On Tue, Feb 13, 2007 at 09:52:39AM +0900, Ian Kent wrote:
> > Indeed.
> > Which kernel can you use?
> > I believe that 2200 had another problem so can you use an fc5 kernel
> > later than that?
> 
> I've ported your patch to 2257 (nothing special, only moved lines),
> and it seems to work beautifully.  I'm enlarging the testing.

OK. But be aware that there may (probably) be another patch missing from
that kernel. If you run into problems we'll go further into it.

Ian


