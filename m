Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbYBTW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbYBTW0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765437AbYBTW0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:26:03 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39271 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765094AbYBTW0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:26:01 -0500
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@MIT.EDU>,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu
In-Reply-To: <20080216063129.GA8592@lst.de>
References: <20080215223721.9E0A088A@kernel>
	 <20080215223730.90A85F4A@kernel> <20080216003219.GA26734@mit.edu>
	 <1203122979.13230.3.camel@nimitz.home.sr71.net>
	 <20080216010030.GC26734@mit.edu>
	 <20080215171119.578bd302.akpm@linux-foundation.org>
	 <20080216063129.GA8592@lst.de>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 14:25:52 -0800
Message-Id: <1203546352.29823.57.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-16 at 07:31 +0100, Christoph Hellwig wrote:
> once we put pieces in the first three patches would be useful aswell,
> to easily catch additions in the next cycle that might be adding
> NULL-vfsmount calls to dentry_open.

So, we want

	"[PATCH 07/30] r/o bind mounts: stub functions"
and 
	"[PATCH 03/30] check for null vfsmount in dentry_open()"

But what's the third patch?

-- Dave

