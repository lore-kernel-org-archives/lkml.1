Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZGIHVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZGIHVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbZGIHVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:21:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49615 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZGIHVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:21:21 -0400
Date: Thu, 9 Jul 2009 09:21:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: tridge@samba.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709072113.GC7992@elf.ucw.cz>
References: <19026.38137.63807.427511@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <1247066878.4159.153.camel@mulgrave.site> <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk> <1247069202.4159.212.camel@mulgrave.site> <20090708171848.21633768@lxorguk.ukuu.org.uk> <19029.29008.522539.547122@samba.org> <87skh68lys.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skh68lys.fsf@devron.myhome.or.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 14:27:39, OGAWA Hirofumi wrote:
> tridge@samba.org writes:
> 
> > Can you explain what standard you think should be applied to patent
> > workaround patches for them to be acceptable? I'd like to know if
> > there is the possibility of us finding some agreement in the future or
> > not.
> 
> You are talking different thing than patch. Please stop it.

Uff, the patch is obviously trash -- takes working code, replaces it
with known broken code -- so some justification is neccessary.

Outside of U.S., the patch makes obviously no sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
