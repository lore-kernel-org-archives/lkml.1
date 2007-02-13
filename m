Return-Path: <linux-kernel-owner+w=401wt.eu-S1751075AbXBMUnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbXBMUnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXBMUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:43:13 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4521 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbXBMUnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:43:11 -0500
Date: Tue, 13 Feb 2007 21:43:10 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Ian Kent <raven@themaw.net>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs protocol somewhere
Message-ID: <20070213204310.GA68966@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
References: <1170871661.3415.36.camel@raven.themaw.net> <20070207181817.GA75717@dspnet.fr.eu.org> <1170901990.3383.18.camel@raven.themaw.net> <1171262594.18376.13.camel@raven.themaw.net> <20070212135749.GA1681@dspnet.fr.eu.org> <1171327959.3377.3.camel@raven.themaw.net> <20070213085053.GA74257@dspnet.fr.eu.org> <45D1C61F.9090509@redhat.com> <20070213155405.GA33765@dspnet.fr.eu.org> <1171388115.3377.23.camel@raven.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171388115.3377.23.camel@raven.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 02:35:15AM +0900, Ian Kent wrote:
> On Tue, 2007-02-13 at 16:54 +0100, Olivier Galibert wrote:
> > Don't they require autofs5 to be of any use though?  That's not going
> > to be in fc until it's out of beta I guess.
> 
> Not really?
> 
> [raven@fc6 ~]$ cat /etc/redhat-release 
> Fedora Core release 6 (Zod)
> [raven@fc6 ~]$ rpm -q autofs
> autofs-5.0.1-0.rc3.16

Oh cool, my guess was wrong.


> The Rawhide or FC-6 srpm should build fine on FC5.

The .spec that comes with the tgz works without a hitch too.  I guess
fc6 is going to have a *really* working automounter RSN then.

  OG.

