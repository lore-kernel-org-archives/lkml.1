Return-Path: <linux-kernel-owner+w=401wt.eu-S1751195AbZLHIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbZLHIxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZLHIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:53:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZLHIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:53:45 -0500
Date: Tue, 8 Dec 2009 09:53:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091208085342.GD12264@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <20091206074120.GA1615@ucw.cz>
 <1260107487.23633.55.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260107487.23633.55.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-06 05:51:27, Daniel Walker wrote:
> On Sun, 2009-12-06 at 08:41 +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > Where is the tree with HTC Dream support? I thought it was 
> > > > 
> > > > http://git.kernel.org/?p=linux/kernel/git/dwalker/linux-msm.git;a=summary
> > > > 
> > > > but it does not seem to contain basic dream support (board file and
> > > > serial console) and I thought that was going to linus for 2.6.33...?
> > > 
> > > It's here
> > > 
> > > git://codeaurora.org/quic/kernel/dwalker/linux-msm.git
> > ...
> > > It's been in Linux-next for maybe two weeks .. I've been trying to
> > > decide if I should submit it for 2.6.33. I'm going to be adding boat
> > > loads of additional msm code and doing a fairly large merge for
> > > 2.6.34 .. So your code would get better testing if we wait for that.
> > > 
> > > However, If you really want it in 2.6.33 I'll try to accommodate you.
> > 
> > It would be good to get it in 2.6.33, so that we can build on it, and
> > so that you are marked as official maintainer etc. I do not think that
> > code would benefit from any additional delays...
> 
> Ok. Fine with me, unless someone else has a specific objection .

Any news here?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
