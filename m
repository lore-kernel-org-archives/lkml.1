Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbXBENeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbXBENeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932432AbXBENeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:34:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbXBENeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:34:20 -0500
Date: Mon, 5 Feb 2007 08:34:10 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: ebuddington@wesleyan.edu, Dave Airlie <airlied@gmail.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
Message-ID: <20070205133410.GA4121@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
	ebuddington@wesleyan.edu, Dave Airlie <airlied@gmail.com>,
	Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net> <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com> <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net> <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com> <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net> <45C5AEA5.2040501@tungstengraphics.com> <20070204192645.GA5169@pool-71-161-131-9.spfdma.east.verizon.net> <20070204230544.GB8960@redhat.com> <45C72976.9090201@tungstengraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C72976.9090201@tungstengraphics.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 01:56:22PM +0100, Thomas Hellström wrote:
 > Dave Jones wrote:
 > > On Sun, Feb 04, 2007 at 02:26:59PM -0500, Eric Buddington wrote:
 > >  > On Sun, Feb 04, 2007 at 11:00:05AM +0100, Thomas Hellstr?m wrote:
 > >  > > Eric,
 > >  > > Sorry for the breakage. Can you try the attached patch and see if it 
 > >  > > fixes the problem.
 > >  > > 
 > >  > > /Thomas
 > >  > 
 > >  > Thomas,
 > >  > 
 > >  > Thanks! That seems to fix it:
 > >
 > > Great.  Thomas, can you resend me that patch with a description & Signed-off-by ?
 > > (Also for some reason that one looks like it was MIME damaged, git-am wouldn't eat it)
 > >
 > > 		Dave
 > >
 > >   
 > Dave,
 > I'll post an updated complete patch. The previous one was really only 
 > for Eric to try.

Can you send just an incremental against what's in agpgart.git right now?

Thanks,

		Dave

-- 
http://www.codemonkey.org.uk
