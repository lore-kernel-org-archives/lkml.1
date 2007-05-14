Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbXENWAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbXENWAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXENWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:00:10 -0400
Received: from gw.goop.org ([64.81.55.164]:58376 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbXENWAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:00:09 -0400
Message-ID: <4648DBE4.9000903@goop.org>
Date: Mon, 14 May 2007 15:00:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	<46489818.4000408@goop.org>	<20070514125946.0f74221c.akpm@linux-foundation.org>	<4648C062.5090704@goop.org>	<20070514133745.5bfc34ac.akpm@linux-foundation.org>	<1179176058.3703.85.camel@mulgrave.il.steeleye.com>	<20070514140530.8e0491cf.akpm@linux-foundation.org>	<4648D03F.4090407@goop.org> <20070514145158.ca5f6174.akpm@linux-foundation.org>
In-Reply-To: <20070514145158.ca5f6174.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well, let's get the build fix in place first and then we can feed
> the cleanup in later on, in a more leisurely fashion?
>   

If you like.  Are all the Voyager users standing outside your office
with pitchforks, demanding satisfaction?

    J
