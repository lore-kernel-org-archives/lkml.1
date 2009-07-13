Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZGMSfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZGMSfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZGMSfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:35:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbZGMSfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:35:21 -0400
Date: Mon, 13 Jul 2009 20:35:14 +0200
From: Karel Zak <kzak@redhat.com>
To: Peter Breitenlohner <peb@mppmu.mpg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2 -- a small patch
Message-ID: <20090713183514.GF6299@nb.net.home>
References: <20090702181031.GB4122@nb.net.home> <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 07:05:19PM +0200, Peter Breitenlohner wrote:
> I just tried to build util-linux-ng-2.16-rc2 (i686/x86_64 linux-gnu
> with gcc-3.4.6, libc-2.3.6), but in order to succeed I had to apply the
> attached patch (#include <stdarg.h> from shlibs/blkid/src/blkidP.h).

 Applied, thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
