Return-Path: <linux-kernel-owner+w=401wt.eu-S1763925AbXKNTyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763925AbXKNTyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbXKNTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:53:57 -0500
Received: from gw.goop.org ([64.81.55.164]:33597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbXKNTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:53:56 -0500
Message-ID: <473B5242.5050606@goop.org>
Date: Wed, 14 Nov 2007 11:53:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Keir Fraser <keir@xensource.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
References: <20071015204840.074767068@goop.org>	<20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org>	<20071113232258.GA10338@kroah.com> <473B4132.5030402@goop.org> <20071114190335.GA10024@kroah.com>
In-Reply-To: <20071114190335.GA10024@kroah.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ok, that's fine, but can you send some patches that I can apply?  :)

The patches you've already queued for stable are all that's needed. 
Including the xfs one, despite Andi's reservations about it; Dave
Chinner has a better fix, but as far as I know he hasn't submitted it
for stable, and the workaround is enough to get things going.

I have one additional patch; I'll send it shortly (once Linus picks it
up...).

    J
