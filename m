Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbXBEM4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbXBEM4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXBEM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:56:44 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:1177 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932258AbXBEM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:56:43 -0500
Message-ID: <45C72976.9090201@tungstengraphics.com>
Date: Mon, 05 Feb 2007 13:56:22 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, ebuddington@wesleyan.edu,
       Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Dave Airlie <airlied@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net> <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com> <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net> <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com> <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net> <45C5AEA5.2040501@tungstengraphics.com> <20070204192645.GA5169@pool-71-161-131-9.spfdma.east.verizon.net> <20070204230544.GB8960@redhat.com>
In-Reply-To: <20070204230544.GB8960@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sun, Feb 04, 2007 at 02:26:59PM -0500, Eric Buddington wrote:
>  > On Sun, Feb 04, 2007 at 11:00:05AM +0100, Thomas Hellstr?m wrote:
>  > > Eric,
>  > > Sorry for the breakage. Can you try the attached patch and see if it 
>  > > fixes the problem.
>  > > 
>  > > /Thomas
>  > 
>  > Thomas,
>  > 
>  > Thanks! That seems to fix it:
>
> Great.  Thomas, can you resend me that patch with a description & Signed-off-by ?
> (Also for some reason that one looks like it was MIME damaged, git-am wouldn't eat it)
>
> 		Dave
>
>   
Dave,
I'll post an updated complete patch. The previous one was really only 
for Eric to try.

/Thomas



