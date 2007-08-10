Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbXHJWjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbXHJWjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXHJWiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:38:51 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2672 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbXHJWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:38:49 -0400
Date: Fri, 10 Aug 2007 17:43:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Michael Buesch <mb@bu3sch.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810214340.GA28812@tuxdriver.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070810200801.GA16714@hall.aurel32.net> <20070810132019.bc218797.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810132019.bc218797.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 01:20:19PM -0700, Andrew Morton wrote:

> git-wireless now has the usual git catastrophe when merging it against the
> recently-discovered net-2.6.24 tree, so I'll need to do something about
> that first.

I have rebased the wireless-dev tree, and the mm-master branch there
should specifically avoid these merge conflicts.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
