Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXENW53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXENW53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbXENW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:57:21 -0400
Received: from gw.goop.org ([64.81.55.164]:44115 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760115AbXENW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:57:20 -0400
Message-ID: <4648E94D.6010902@goop.org>
Date: Mon, 14 May 2007 15:57:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	 <20070514140530.8e0491cf.akpm@linux-foundation.org>	 <4648D03F.4090407@goop.org> <200705142358.09529.ak@suse.de>	 <20070514152905.3604fa20.akpm@linux-foundation.org> <1179182555.3703.102.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1179182555.3703.102.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Let me do it.
>
> These are the two patches, tested and working on Voyager.
>
> The order of application is
>
> i386-common-smp.patch
> i386-fix-voyager-build.patch
>   

Yep, looks fine to me.  The only difference from the ones I just posted
appears to be a little bit of whitespace.

    J
