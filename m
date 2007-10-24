Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbXJXAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbXJXAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXJXAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:33:18 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42152 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbXJXAdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:33:18 -0400
Date: Tue, 23 Oct 2007 17:32:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
Message-ID: <20071024003253.GS3660@sequoia.sous-sol.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E9260.6000704@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Chris Wright wrote:
> > Yes, and I think we can still improve performance although I can't see
> > anyway to help out the modular case, so I guess it will have to incur
> > the hit that's always been there.  
> 
> Broaden the paravirt patching machinery?

Yup, that's essentially what we've been talking about.

thanks,
-chris
