Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXFXUpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXFXUpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXFXUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:45:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56017 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410AbXFXUpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:45:45 -0400
Date: Sun, 24 Jun 2007 22:43:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070624204353.GD21757@elf.ucw.cz>
References: <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain> <20070622173056.GA873@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622173056.GA873@think.oraclecorp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> But as someone who doesn't use either SElinux or AA, I really hope
> we can get past the part of the debate where:
> 
> while(1)
>     AA) we think we're making users happy with pathname security
>     SELINUX) pathname security sucks

(Hopefully I'll not be fired for this. :-)

Yes, we _are_ making users happy with AA.

Questions is if we are making them secure. :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
