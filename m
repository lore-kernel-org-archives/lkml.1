Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXKNAlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXKNAlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760911AbXKNAle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:41:34 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:18996 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760438AbXKNAlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VpzE6nviNwi4KRPBmtaAAQerIhmP7dPR3ZKU9SBMKMGXUgI9Um6snJIDqebIfJJEXY87rRW83giXWq9DLCa5Q6w8GG+R742y+avFLBvsDuAZNuBNP9xshrx+SjsKvJc2w5dhHtfGJGhN4WW+hQ0A0g22BOHbPhWDncwvGkCz4io=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG] New Kernel Bugs
Date: Tue, 13 Nov 2007 17:41:06 -0700
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@kernel.org>, Theodore Tso <tytso@mit.edu>,
       Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113175610.GE4250@stusta.de> <4739F399.2010605@googlemail.com>
In-Reply-To: <4739F399.2010605@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131741.06509.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 11:57, Gabriel C wrote:
> > The main problem is finding experienced developers who spend time on
> > looking into bug reports.
>
> There are already. IMO the problem is the development model.
>
> There are tons new features in each new kernel release and 'tons new bugs'
> which are not fixed during the release cycle nor in the .XX stable kernels.
>
> Maybe after XX kernel releases there should be one just with bug-fixes
> _without_ any new features , eg: cleaning bugs from bugzilla , know
> regressions , cleaning up code , removing broken drivers and the like.

Won't work. You cannot force people to work on things they don't
find interesting, long-term.
--
vda
