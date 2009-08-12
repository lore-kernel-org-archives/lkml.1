Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZHLHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZHLHfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZHLHfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:35:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:45791 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZHLHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:35:46 -0400
Date: Wed, 12 Aug 2009 10:35:16 +0300
From: "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090812073516.GB6453@cachaca>
Reply-To: tiago.vignatti@nokia.com
References: <1249969927-884-1-git-send-email-airlied@gmail.com> <20090811161746.7b8878aa@jbarnes-g45> <20090811162103.1b2a65c9@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811162103.1b2a65c9@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Aug 2009 07:35:18.0335 (UTC) FILETIME=[70C49CF0:01CA1B1F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:21:03AM +0200, Jesse Barnes wrote:
> Oh yeah, and we should get the documentation merged too.  I can handle
> that or you can send it to Randy.  Tiago?

Okay, I can handle this documentation pretty easy. 

But honestly I'm not sure we (or some future developer) will use it. The
header (include/linux/vgaarb.h) is already very nice documented. So, tell me
what do you think Jesse.


Cheers,

            Tiago
