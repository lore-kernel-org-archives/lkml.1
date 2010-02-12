Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0BLElq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 23:41:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39756 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab0BLElo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 23:41:44 -0500
Date: Fri, 12 Feb 2010 04:41:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adam Buchbinder <adam.buchbinder@gmail.com>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the drm tree
In-Reply-To: <20100212151223.21746bc7.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1002120440510.26950@skynet.skynet.ie>
References: <20100212151223.21746bc7.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Jiri,

Can we drop any cleanups to atombios.h?

This file comes from AMD and we normally drop it into place, so they just 
get overwritten next time.

Dave.
