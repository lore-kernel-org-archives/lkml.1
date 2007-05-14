Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbXENVJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbXENVJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbXENVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:09:06 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:32880 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbXENVJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:09:05 -0400
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070514140530.8e0491cf.akpm@linux-foundation.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	 <46489818.4000408@goop.org>
	 <20070514125946.0f74221c.akpm@linux-foundation.org>
	 <4648C062.5090704@goop.org>
	 <20070514133745.5bfc34ac.akpm@linux-foundation.org>
	 <1179176058.3703.85.camel@mulgrave.il.steeleye.com>
	 <20070514140530.8e0491cf.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 16:08:58 -0500
Message-Id: <1179176938.3703.89.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 14:05 -0700, Andrew Morton wrote:
> OK, thanks.  I hereby propose that I send the below
> (voyager-fix-build-broken-by-shift-to-smp_ops.patch) to Linus later
> today,
> provided it passes local testing.
> 
> All those in favour say aye?

Boots for me on my voyagers, so aye.

James


