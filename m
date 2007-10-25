Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXJYBnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXJYBnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXJYBm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:42:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57291 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbXJYBm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:42:56 -0400
Date: Wed, 24 Oct 2007 17:41:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071025004128.GC3660@sequoia.sous-sol.org>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com> <20071024233200.GJ30533@stusta.de> <alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> Do other people want to stand up and be "LSM maintainers" in the sense 
> that they also end up being informed members who can also stand up for new 
> modules and help merge them, rather than just push the existing one(s)? 
> Chris? Casey? Crispin?

Stephen and James, despite their clear bias towards SELinux, do try to
give good feedback.  But you are right, there's not enough active help
for people trying to make a contribution to get their code in shape.
Many of the modules that come along have been misguided conceptually,
but I think that e.g. apparmor, tomoyo, smack could use that kind
of constructive help to get into final mergable shape.  Personally,
I haven't spent nearly enough time reviewing those, my apologies to
those developers.  So, yes, help is welcome.

thanks,
-chris
