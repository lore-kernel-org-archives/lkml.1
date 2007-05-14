Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXENRKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXENRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXENRKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:10:46 -0400
Received: from gw.goop.org ([64.81.55.164]:39393 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbXENRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:10:45 -0400
Message-ID: <46489818.4000408@goop.org>
Date: Mon, 14 May 2007 10:10:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> From: Jeremy Fitzhardinge <jeremy@xensource.com>
> Subject: [VOYAGER] fix build broken by shift to smp_ops
>
> This adds an smp_ops for voyager, and hooks things up appropriately.
> This is the first baby-step to making subarch runtime switchable.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>
> Rediffed to work in the absence of the smp consolidation patch
>   

I think Andrew is carrying that in -mm.  If you're proposing this for
git, then we may as well pull in that patch too.

    J
