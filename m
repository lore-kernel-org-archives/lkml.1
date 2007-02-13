Return-Path: <linux-kernel-owner+w=401wt.eu-S1750767AbXBMQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767AbXBMQAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXBMQAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:00:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXBMQAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:00:54 -0500
Message-ID: <45D1DFD9.2050308@redhat.com>
Date: Tue, 13 Feb 2007 10:57:13 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ian Kent <raven@themaw.net>, "Hack inc." <linux-kernel@vger.kernel.org>,
       autofs@linux.kernel.org
Subject: Re: [PATCH 1/2] Re: [autofs] Bad race condition in the new autofs
 protocol somewhere
References: <20070207173414.GA64492@dspnet.fr.eu.org> <1170871661.3415.36.camel@raven.themaw.net> <20070207181817.GA75717@dspnet.fr.eu.org> <1170901990.3383.18.camel@raven.themaw.net> <1171262594.18376.13.camel@raven.themaw.net> <20070212135749.GA1681@dspnet.fr.eu.org> <1171327959.3377.3.camel@raven.themaw.net> <20070213085053.GA74257@dspnet.fr.eu.org> <45D1C61F.9090509@redhat.com> <20070213155405.GA33765@dspnet.fr.eu.org>
In-Reply-To: <20070213155405.GA33765@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
>> If you get the patches into -stable they will end up in Fedora
>> kernels automatically. 2288 (based on 2.6.19) is in testing now...
> 
> Don't they require autofs5 to be of any use though?  That's not going
> to be in fc until it's out of beta I guess.

I didn't realize you needed other updates... never mind.


