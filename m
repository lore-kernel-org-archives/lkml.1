Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZINFzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZINFzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZINFzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:55:02 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41002 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZINFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:55:01 -0400
Date: Mon, 14 Sep 2009 14:54:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's in sh-2.6.git for 2.6.32?
Message-ID: <20090914055450.GG15078@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090914054854.GF15078@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914054854.GF15078@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 02:48:54PM +0900, Paul Mundt wrote:
>  drivers/block/aoe/aoe.h                            |    2 +-
>  drivers/block/aoe/aoeblk.c                         |   12 +-
>  drivers/block/aoe/aoedev.c                         |    1 -
>  drivers/gpu/drm/i915/i915_gem.c                    |    6 +-
>  drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
>  drivers/gpu/drm/i915/intel_drv.h                   |    1 -
>  drivers/gpu/drm/i915/intel_tv.c                    |    1 -

These obviously are just a result of the suspend tree being a couple of
changes ahead which I failed to account for, so just pretend these don't
exist.
