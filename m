Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXJXAbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXJXAbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXJXAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:31:31 -0400
Received: from gw.goop.org ([64.81.55.164]:59396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXJXAbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:31:31 -0400
Message-ID: <471E9260.6000704@goop.org>
Date: Tue, 23 Oct 2007 17:31:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org>
In-Reply-To: <20071023051642.GA3908@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> Yes, and I think we can still improve performance although I can't see
> anyway to help out the modular case, so I guess it will have to incur
> the hit that's always been there.  

Broaden the paravirt patching machinery?

    J
