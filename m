Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbZHESgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbZHESgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZHESgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:36:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZHESgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:36:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
Date: Wed, 5 Aug 2009 20:37:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, Eric Miao <eric.y.miao@gmail.com>,
       "- Cortez -" <omegamoon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel@jasper.es
References: <20090704024416.GA1345@ucw.cz> <1249492113.9324.369.camel@macbook.infradead.org> <20090805172238.GM13236@buzzloop.caiaq.de>
In-Reply-To: <20090805172238.GM13236@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052037.15066.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Daniel Mack wrote:
> On Wed, Aug 05, 2009 at 06:08:33PM +0100, David Woodhouse wrote:
> > On Wed, 2009-08-05 at 18:30 +0200, Daniel Mack wrote:
> > > 
> > > That bug hit me as well, and as in Cortez' case, reverting 15bce40
> > > fixed
> > > it for me on a PXA3xx platform.
> > 
> > Can you confirm that the fix in the mtd-2.6.git tree is sufficient?
> 
> Yep, thanks!

Any pointer to the fix patch, please?

Rafael
