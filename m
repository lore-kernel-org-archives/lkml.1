Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXJYAaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXJYAaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJYAaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:30:03 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35856 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbXJYAaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:30:01 -0400
Date: Wed, 24 Oct 2007 17:23:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071025002356.GB3660@sequoia.sous-sol.org>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446110.89443.qm@web36608.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> And don't give me the old "LKML is a tough crowd" feldercarb.
> Security modules have been much worse. Innovation, even in
> security, is a good thing and treating people harshly, even
> "for their own good", is an impediment to innovation.

I agree that innovation is critical to the success of Linux, and security
is not immune to that.  The trouble is that most of the security modules
that have come forward have had some real serious shortcomings.  I do
believe it is prudent to keep in-tree security sensitive code under
high scrutiny because we do not want to create security holes by adding
problematic security code.

thanks,
-chris
