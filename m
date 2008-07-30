Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbYG3V0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbYG3V0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYG3VZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:25:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbYG3VZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:25:50 -0400
Date: Wed, 30 Jul 2008 14:22:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KOJ1s-0002a5-Im@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0807301418270.3277@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org> <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
 <E1KOJ1s-0002a5-Im@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> 
> Huh?  I did exactly that, and that patch got NAK'ed by you and Nick:

Umm. That was during the late -rc sequence (what, -rc8?) where I wanted a 
minimal "let's fix it". Not that anybody then apparently cared, which is 
probably just as well.

Then you did NOTHING AT ALL about it, now the merge window is over, and 
you complain again, with what looks like basically the same patch that was 
already rejected earlier.

Hellooo..

			Linus
