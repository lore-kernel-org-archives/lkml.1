Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbZCAAqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbZCAAqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZCAAqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:46:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2753 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbZCAAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:46:34 -0500
Date: Sun, 1 Mar 2009 00:46:19 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Theodore Tso <tytso@mit.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090301004618.GA12909@sirena.org.uk>
References: <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301001829.GA10751@mit.edu>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 07:18:29PM -0500, Theodore Tso wrote:

> Just to shut up checkpatch, I'm going to feel the urge to shake a
> checkpatch maintainer warmly by the throat.

> Sometimes, all that is needed is:

> ------------
> ext4: Fix spelling error: successfull
> 
> Signed-off-by: "Trivial Patch Submitter" <spelling@nits.org>
> ------------

As I've said already I pretty much agree with this.

The reason I sent the patch was that sending changelogs like that for
trivial changes is getting me negative feedback and I'm seeing other
comments about "unchangeloged patches" on the lists so I'm pretty sure
it's not just something I'm doing.  I'm not saying I'm always blameless
here but when people are using terms like like "unchangeloged" it really
does suggest that one line changelogs are just considered not to have
changelogs.

Some consistency would be good here.
