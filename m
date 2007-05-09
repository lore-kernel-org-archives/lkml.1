Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbXEISVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbXEISVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXEISVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:21:04 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:18348 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566AbXEISVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:21:02 -0400
Date: Wed, 9 May 2007 20:18:38 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-ID: <20070509181838.GA17551@mailshack.com>
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas> <20070509085434.GA13712@mailshack.com> <4641FC18.3030506@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641FC18.3030506@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Wed, 09 May 2007 20:19:59 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:51:36AM -0700, H. Peter Anvin wrote:
> Alexander van Heukelum wrote:
> > 
> > Hi!
> > 
> > I'm making coffee now. I just don't see what I missed? Maybe you were
> > led astray by the new PARAM_VESA_PAD I added?
> > 
> 
> Again, I object to changing a documented interface when it's not
> necessary to do so.  Just declare the structure packed.

That would be like this, right?

http://www.ussg.iu.edu/hypermail/linux/kernel/0705.1/0383.html

Greetings,
	Alexander
