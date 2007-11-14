Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXKNNfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXKNNfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXKNNfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:35:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbXKNNfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:35:39 -0500
Message-ID: <473AF9A5.50707@suse.de>
Date: Wed, 14 Nov 2007 14:35:33 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Adrian Bunk <bunk@kernel.org>,
       alsa-devel@alsa-project.org, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, Benoit Boissinot <bboissin@gmail.com>,
       Mark Lord <liml@rtr.ca>, linux-input@atrey.karlin.mff.cuni.cz,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <200711131739.45820.vda.linux@googlemail.com> <20071114072715.GO4250@stusta.de> <200711140046.20391.vda.linux@googlemail.com> <20071114133034.GR17785@parisc-linux.org>
In-Reply-To: <20071114133034.GR17785@parisc-linux.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Nov 14, 2007 at 12:46:20AM -0700, Denys Vlasenko wrote:
>> Finally they replied and asked to rediff it against their
>> git tree. I did that and sent patches back. No reply since then.
>>
>> And mind you, the patch is not trying to do anything
>> complex, it mostly moves code around, removes 'inline',
>> adds 'const'. What should I think about it?
> 
> I'm waiting for an ACK/NAK from Hannes, the maintainer.  What should I
> do?
> 
I haven't actually been able to test it here (too busy, sorry). If someone
else confirms it does it's job then

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
