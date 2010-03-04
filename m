Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0CDSuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:50:07 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39426 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0CDSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:50:05 -0500
Date: Thu, 4 Mar 2010 18:50:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304185002.GA23532@srcf.ucam.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:43:30AM -0800, Linus Torvalds wrote:

> Or is there a version of X that can handle _both_ the 0.0.15 and the 
> 0.0.16 interfaces?

When you asked that nouveau was merged, people explicitly told you that 
the reason it hadn't been was because the interface was unstable and 
userspace would break. You asked that it be merged anyway, and now 
you're unhappy because the interface has changed and userspace has 
broken?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
