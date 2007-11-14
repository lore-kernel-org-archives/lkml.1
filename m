Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXKNNau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXKNNau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXKNNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:30:38 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46835 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXKNNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:30:37 -0500
Date: Wed, 14 Nov 2007 06:30:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Adrian Bunk <bunk@kernel.org>, alsa-devel@alsa-project.org,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       linux-input@atrey.karlin.mff.cuni.cz, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114133034.GR17785@parisc-linux.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <200711131739.45820.vda.linux@googlemail.com> <20071114072715.GO4250@stusta.de> <200711140046.20391.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711140046.20391.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:46:20AM -0700, Denys Vlasenko wrote:
> Finally they replied and asked to rediff it against their
> git tree. I did that and sent patches back. No reply since then.
> 
> And mind you, the patch is not trying to do anything
> complex, it mostly moves code around, removes 'inline',
> adds 'const'. What should I think about it?

I'm waiting for an ACK/NAK from Hannes, the maintainer.  What should I
do?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
