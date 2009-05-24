Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZEXKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZEXKmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 06:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZEXKmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 06:42:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37611 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZEXKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 06:42:10 -0400
Date: Sun, 24 May 2009 11:42:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Joe Perches <joe@perches.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20090524104159.GA4933@sirena.org.uk>
References: <cover.1243131992.git.joe@perches.com> <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com> <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com> <1243135358.3560.1.camel@Joe-Laptop.home> <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
	linux-kernel@vger.kernel.org from all but "THE REST"
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 10:28:19PM -0600, Grant Likely wrote:
> On Sat, May 23, 2009 at 9:22 PM, Joe Perches <joe@perches.com> wrote:

> > Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.

> Is that actually true in practice?  At least on linuxppc-dev, very few
> patches are cc'd to lkml.  I don't remember ever being prompted to cc
> lkml on all patches, and I haven't been prompting others to do so.

I regularly have to remind people to CC lkml as well as the architecture
list for the platform they're making changes to kernel wide subsystems
(partcularly the regulator framework).
