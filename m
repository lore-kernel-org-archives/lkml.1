Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbXKMRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbXKMRu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbXKMRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:50:12 -0500
Received: from rtr.ca ([76.10.145.34]:1714 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbXKMRuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:50:10 -0500
Message-ID: <4739E3D0.10201@rtr.ca>
Date: Tue, 13 Nov 2007 12:50:08 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu>
In-Reply-To: <20071113164650.GA28493@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> for example git-bisect was godsent. I remember that years ago bisection 
> of a bug was a very laborous task so that it was only used as a final, 
> last-ditch approach for really nasty bugs. Today we can autonomouly 
> bisect build bugs via a simple shell command around "git-bisect run", 
> without any human interaction! This freed up testing resources 
..

It's only a godsend for the few people who happen to be kernel developers
and who happen to already use git.

It's a 540MByte download over a slow link for everyone else.

-ml
