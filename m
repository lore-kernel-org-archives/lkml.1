Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0CDTMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:12:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52109 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0CDTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:12:12 -0500
Date: Thu, 4 Mar 2010 19:12:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304191206.GA24026@srcf.ucam.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <20100304103655.0b14343f@jbarnes-piketon> <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:51:20AM -0800, Linus Torvalds wrote:

> That doesn't change the simple basic issue: how are people with Fedora-12 
> going to test any kernel out now? And are there libdrm versions that can 
> handle _both_ cases, so that people can bisect things? IOW, even if you 
> have a new libdrm, will it then work with the _old_ kernel too?

F-12 continues to ship the -nv driver, which will work fine with any 
kernel version as long as nouveau is disabled.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
