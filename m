Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXFTXv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXFTXv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXFTXvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:51:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbXFTXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:51:41 -0400
Date: Wed, 20 Jun 2007 16:50:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <1182381667.2701.7.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.98.0706201649060.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com> 
 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com> 
 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
 <1182381667.2701.7.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Arjan van de Ven wrote:
> 
> the real fix would be something like this instead:

If people can test this, and confirm it works, please send a patch that 
not only does this ad undoes the Kconfig language.  It looks like the 
right thing to do, but I won't touch it without somebody who actually 
tested these combinarions sending in a patch.

Hmm?

		Linus
