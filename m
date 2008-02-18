Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYBRHG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYBRHG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYBRHGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:06:52 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53392 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYBRHGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:06:51 -0500
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Theodore Tso <tytso@MIT.EDU>,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu
In-Reply-To: <20080215224608.fb5d11b7.akpm@linux-foundation.org>
References: <20080215223721.9E0A088A@kernel>
	 <20080215223730.90A85F4A@kernel> <20080216003219.GA26734@mit.edu>
	 <1203122979.13230.3.camel@nimitz.home.sr71.net>
	 <20080216010030.GC26734@mit.edu>
	 <20080215171119.578bd302.akpm@linux-foundation.org>
	 <20080216063129.GA8592@lst.de>
	 <20080215224608.fb5d11b7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 23:06:43 -0800
Message-Id: <1203318403.15017.7.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 22:46 -0800, Andrew Morton wrote:
> hrm, well, how about putting up a complete and suitably-changelogged patch
> series for Linus to look at?  That's be a Dave thing I guess.

I'll look at it on Wednesday.  I'm offline until then.

> I wasn't overawed by the initial patch - why not make those stubs inlined
> to truly add zero cost??

What I sent was the exact same thing I had from the original patch
series.  They weren't inlined because shortly after that in the series,
we make them much bigger.  Merging that exact patch is the easiest for
me, but I see your point.  I'll rework it  with the others.

-- Dave

