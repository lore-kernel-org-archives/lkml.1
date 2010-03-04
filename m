Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0CDUqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:46:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40140 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0CDUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:46:07 -0500
Date: Thu, 4 Mar 2010 20:46:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304204604.GA25850@srcf.ucam.org>
References: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain> <20100304190450.GA23807@srcf.ucam.org> <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain> <20100304192524.GA24253@srcf.ucam.org> <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain> <20100304195302.GA24856@srcf.ucam.org> <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:07:19PM -0800, Linus Torvalds wrote:

> Do you seriously think that that wouldn't make life easier EVEN FOR THOSE 
> DEVELOPERS that you claim to speak up for?

Compared to dealing with Mesa's build system? I honestly wouldn't want 
to say. But you're right that pushing the job of supporting multiple 
interfaces out to userspace would be much more tractable here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
