Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbXKNPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbXKNPEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXKNPEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:04:44 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35255 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbXKNPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:04:43 -0500
Date: Wed, 14 Nov 2007 16:04:03 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthias Urlichs <smurf@smurf.noris.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <20071114145938.GA5071@smurf.noris.de>
Message-ID: <Pine.LNX.4.64.0711141603140.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141538250.15844@twin.jikos.cz> <20071114145938.GA5071@smurf.noris.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Matthias Urlichs wrote:

> > $ git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.24-rc2-mm1
> > error: no such remote ref refs/tags/v2.6.24-rc2-mm1
> Yeah, the import took too long and thus broke.
> Should be fixed by now.

Hi Matthias,

hmm, still doesn't work even if I try to fetch the tag directly from hera 
(i.e. not waiting for sync to git mirrors on kernel.org):

$ git-fetch jikos@master.kernel.org:/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.24-rc2-mm1
error: refs/heads/master points nowhere!
error: refs/heads/master points nowhere!
error: no such remote ref refs/tags/v2.6.24-rc2-mm1
fatal: Fetch failure: jikos@master.kernel.org:/pub/scm/linux/kernel/git/smurf/linux-trees.git

-- 
Jiri Kosina
