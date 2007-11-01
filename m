Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbXKAP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbXKAP5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXKAP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:57:06 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:63556 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXKAP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:57:05 -0400
X-Greylist: delayed 2577 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 11:57:04 EDT
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Sebastian Siewior <lkml@mk.breakpoint.cc>
Subject: Re: 2.4.24-rc1-git: crash on shutdown/unmount?
Date: Thu, 1 Nov 2007 15:12:07 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@ORACLE.COM>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710311917.21441.alistair@devzero.co.uk> <20071101105108.GD5037@kernel.dk> <20071101115108.GA6615@Chamillionaire.breakpoint.cc>
In-Reply-To: <20071101115108.GA6615@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011512.08132.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 11:51:08 Sebastian Siewior wrote:
> * Jens Axboe | 2007-11-01 11:51:09 [+0100]:
> >On Wed, Oct 31 2007, Alistair John Strachan wrote:
> >> Hi Jens,
> >>
> >> I guessed from the oops that you might have an idea what's causing this
> >> oops on shutdown/unmount. The git version (describe), a screenshot
> >> showing the oops, a config, and dmesg for a booted kernel are available
> >> from:
> >>
> >> http://devzero.co.uk/~alistair/oops-20071031/
> >>
> >> I went back to -rc1 and it still happens there too. If you need any more
> >> information or want me to bisect it, please let me know.
> >
> >Does this work for you?
>
> Yes it does.
>
> Acked-by Sebastian Siewior <sebastian@breakpoint.cc>

Yep, thanks Jens. Working fine here.

Tested-by: Alistair John Strachan <alistair@devzero.co.uk>

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
