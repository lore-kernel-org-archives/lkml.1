Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbXENV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbXENV6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXENV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:58:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXENV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:58:42 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Date: Mon, 14 May 2007 23:58:09 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com> <20070514140530.8e0491cf.akpm@linux-foundation.org> <4648D03F.4090407@goop.org>
In-Reply-To: <4648D03F.4090407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142358.09529.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, but only if you don't want to put "i386: move common parts of smp
> into their own file" in front of it, and remove the duplicated code.  I
> could send you a third copy if you like.

Using Jeremy's patch is better than James'

-Andi
