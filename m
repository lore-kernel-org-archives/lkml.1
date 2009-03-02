Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZCBSZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZCBSZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZCBSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:25:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4348 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbZCBSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:25:38 -0500
Date: Mon, 2 Mar 2009 18:24:57 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Theodore Tso <tytso@mit.edu>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302182456.GF19744@sirena.org.uk>
References: <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de> <20090302100158.bb83bec6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302100158.bb83bec6.akpm@linux-foundation.org>
X-Cookie: What hath Bob wrought?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 10:01:58AM -0800, Andrew Morton wrote:

> I think what triggered this was a patch from Mark which had no
> changelog and which had me sitting there wondering wtf it does, whether
> we need it in 2.6.29, whether we need it in 2.6.28.x and earlier and me
> not having the foggiest clue then getting grumpy.

Do you mean no changelog in the body of the e-mail here?  I'm assuming
now that you mean no changelog in the body but when you say "no
changelog" that reads differently.  I'm not saying the changelog was
perfect here but your comments really do read like you felt there was
nothing at all.
