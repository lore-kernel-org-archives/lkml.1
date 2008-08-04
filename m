Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYHDO3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYHDO3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYHDO3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:29:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55515 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754105AbYHDO3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:29:33 -0400
Date: Mon, 4 Aug 2008 15:29:27 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.27-rc1
Message-ID: <20080804142927.GG8301@fluff.org.uk>
References: <1217800985.4179.55.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217800985.4179.55.camel@localhost.localdomain>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 05:03:05PM -0500, James Bottomley wrote:
> This is just a small selection of four fixes, one expanding driver
> bindings and the other three fixing actual bugs (all of which need
> backporting to 2.6.26 I'm afraid).
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> HighPoint Linux Team (1):

I thought group (or non-person) submissions where explicitly
prohibitted in the signoff section in Documentation/SubmittingPatches

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
