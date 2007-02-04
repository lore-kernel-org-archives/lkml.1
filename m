Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbXBDXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbXBDXFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 18:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXBDXFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 18:05:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbXBDXFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 18:05:48 -0500
Date: Sun, 4 Feb 2007 18:05:44 -0500
From: Dave Jones <davej@redhat.com>
To: ebuddington@wesleyan.edu
Cc: Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Dave Airlie <airlied@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
Message-ID: <20070204230544.GB8960@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, ebuddington@wesleyan.edu,
	Thomas Hellstr?m <thomas@tungstengraphics.com>,
	Dave Airlie <airlied@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
	linux-kernel@vger.kernel.org
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net> <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com> <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net> <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com> <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net> <45C5AEA5.2040501@tungstengraphics.com> <20070204192645.GA5169@pool-71-161-131-9.spfdma.east.verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070204192645.GA5169@pool-71-161-131-9.spfdma.east.verizon.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 02:26:59PM -0500, Eric Buddington wrote:
 > On Sun, Feb 04, 2007 at 11:00:05AM +0100, Thomas Hellstr?m wrote:
 > > Eric,
 > > Sorry for the breakage. Can you try the attached patch and see if it 
 > > fixes the problem.
 > > 
 > > /Thomas
 > 
 > Thomas,
 > 
 > Thanks! That seems to fix it:

Great.  Thomas, can you resend me that patch with a description & Signed-off-by ?
(Also for some reason that one looks like it was MIME damaged, git-am wouldn't eat it)

		Dave

-- 
http://www.codemonkey.org.uk
