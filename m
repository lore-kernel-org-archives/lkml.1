Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbXFARJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbXFARJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbXFARJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:09:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60832 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080AbXFARJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:09:03 -0400
Date: Fri, 1 Jun 2007 19:10:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
Message-ID: <20070601171003.GA3040@uranus.ravnborg.org>
References: <46600F1C.5000302@googlemail.com> <b6a2187b0706010628m3d9ffad5y9a76e22719f439b7@mail.gmail.com> <6bffcb0e0706010923y5a2bc729x7388b60cc73d94f7@mail.gmail.com> <b6a2187b0706010943w370f2d5ft4f16a49cc4161012@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0706010943w370f2d5ft4f16a49cc4161012@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 12:43:06AM +0800, Jeff Chua wrote:
> On 6/2/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> >I think that Sam is working on this.
> 
> I'm a bit lost looking at those patches and don't know which ones are
> the appropriate ones I should I apply?
The fix is in -mm and sent to Andi.
So it will likely be merged soon.

I recommemd to ignore the warnings for now.

	Sam
