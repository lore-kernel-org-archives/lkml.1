Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0BLJ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:29:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:51675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab0BLJ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:29:09 -0500
Date: Fri, 12 Feb 2010 10:29:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@linux.ie>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adam Buchbinder <adam.buchbinder@gmail.com>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the drm tree
In-Reply-To: <alpine.DEB.2.00.1002120440510.26950@skynet.skynet.ie>
Message-ID: <alpine.LNX.2.00.1002121028520.30967@pobox.suse.cz>
References: <20100212151223.21746bc7.sfr@canb.auug.org.au> <alpine.DEB.2.00.1002120440510.26950@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Dave Airlie wrote:

> > Hi Jiri,
> 
> Can we drop any cleanups to atombios.h?
> 
> This file comes from AMD and we normally drop it into place, so they just 
> get overwritten next time.

Thanks for letting me know, I have reverted the hunk touching this file.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
