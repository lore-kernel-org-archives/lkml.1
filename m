Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbXBMIu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbXBMIu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXBMIu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:50:59 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2466 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXBMIu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:50:58 -0500
Date: Tue, 13 Feb 2007 09:50:53 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Ian Kent <raven@themaw.net>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs protocol somewhere
Message-ID: <20070213085053.GA74257@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Ian Kent <raven@themaw.net>,
	"Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
References: <20070207173414.GA64492@dspnet.fr.eu.org> <1170871661.3415.36.camel@raven.themaw.net> <20070207181817.GA75717@dspnet.fr.eu.org> <1170901990.3383.18.camel@raven.themaw.net> <1171262594.18376.13.camel@raven.themaw.net> <20070212135749.GA1681@dspnet.fr.eu.org> <1171327959.3377.3.camel@raven.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171327959.3377.3.camel@raven.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 09:52:39AM +0900, Ian Kent wrote:
> Indeed.
> Which kernel can you use?
> I believe that 2200 had another problem so can you use an fc5 kernel
> later than that?

I've ported your patch to 2257 (nothing special, only moved lines),
and it seems to work beautifully.  I'm enlarging the testing.

  OG.

