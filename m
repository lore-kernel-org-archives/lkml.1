Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889Ab0AMNYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0AMNYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600Ab0AMNYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:24:47 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:33688 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab0AMNYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:24:46 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 08:24:46 EST
Date: Wed, 13 Jan 2010 14:15:39 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       sameo@linux.intel.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
Message-ID: <20100113131539.GA3141@stud.informatik.uni-erlangen.de>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de> <alpine.LFD.2.00.1001130704190.532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001130704190.532@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 07:05:33AM -0500, Robert P. J. Day wrote:
> 
>   just FYI, the same information can be found where i post the output
> from my kernel scanning scripts.  specifically, that very typo is
> already documented here:
> 
> http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables#mfd
> 
> rday

	Jep I stumbled upon your reports while having a closer look at
what we found. Strangely while you did find somewhere around 250 such
Issues we are at 90[0] if you count #define-ed CONFIG_* to the
errors. I'll probably try  to look at the difference between our
results.

[0] http://vamos1.informatik.uni-erlangen.de/graph.html
