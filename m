Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbYGCHEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbYGCHEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYGCG5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60760 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbYGCCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:00:53 -0400
X-Sasl-enc: I5fMajbsH7CcM/e2s/PPRLDU2j3sB1XnnjmWTNY+intN 1215050452
Subject: Re: [PATCH] autofs4 - detect invalid direct mount requests
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       autofs@linux.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080702095459.f3761ff4.akpm@linux-foundation.org>
References: <20080620051301.9988.94307.stgit@raven.themaw.net>
	 <20080701141715.62a2132b.akpm@linux-foundation.org>
	 <1214989192.3046.34.camel@raven.themaw.net>
	 <x49tzf8pflh.fsf@segfault.boston.devel.redhat.com>
	 <1215006622.3046.75.camel@raven.themaw.net>
	 <20080702095459.f3761ff4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 09:57:47 +0800
Message-Id: <1215050268.3046.84.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-02 at 09:54 -0700, Andrew Morton wrote:
> On Wed, 02 Jul 2008 21:50:21 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > > > serious bug fixes. It gets rid of an annoyance more than anything as the
> > > > daemon still has to check for it.
> > > >
> > > > It isn't important or urgent, just useful.
> > > 
> > > And I'd still like to see a comment in there!  ;)
> > 
> > OK.
> > 
> > Andrew, could you drop that patch and I'll re-submit it with a better
> > change log entry.
> 
> nope ;)

Hahahaha, OK.

> 
> Today is try-to-get-rc8-mm1-to-work day and that's likely the last
> 2.6.26-rcX-mmY.  We need to get everything we can runtime tested a bit.

Yep, understood.

Ian


