Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYGBVW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYGBVW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYGBVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:20:13 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:41946 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYGBVUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:20:11 -0400
Date: Wed, 2 Jul 2008 23:20:06 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: fix a bug in the asic3 irq demux code
Message-ID: <20080702212006.GD15015@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1215020573.24941.1.camel@localhost.localdomain> <20080702105303.990e6395.akpm@linux-foundation.org> <20080702182219.GB15015@caravaggio> <20080702115903.91c86ed5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702115903.91c86ed5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:59:03AM -0700, Andrew Morton wrote:
> On Wed, 2 Jul 2008 20:22:20 +0200
> Samuel Ortiz <sameo@openedhand.com> wrote:
> 
> > I have set up an mfd tree here: http://git.o-hand.com/?r=linux-mfd
> > with a for-next branch
> 
> Hang on, that's not a git URL.   What's the preferred git:// URL?
git://git.o-hand.com/linux-mfd.git should do it.

Cheers,
Samuel.
