Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYLVLHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYLVLHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYLVLHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:07:01 -0500
Received: from coloquinte.cristau.org ([91.121.16.100]:3614 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYLVLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:07:00 -0500
X-Greylist: delayed 1663 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2008 06:07:00 EST
Date: Mon, 22 Dec 2008 11:39:13 +0100
From: Julien Cristau <jcristau@debian.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Jaswinder Singh <jaswinderlinux@gmail.com>,
       Jaswinder Singh <jaswinder@infradead.org>,
       dri-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] radeon_cp: use request_firmware
Message-ID: <20081222103913.GF10379@patate.is-a-geek.org>
References: <1218095497.4016.3.camel@jaswinder.satnam> <3f9a31f40812191223g72b8a1eey2780f8e1a0ebf7aa@mail.gmail.com> <alpine.DEB.2.00.0812212056060.8861@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0812212056060.8861@skynet.skynet.ie>
X-Operating-System: Linux 2.6.26-1-686 i686
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 20:58:28 +0000, Dave Airlie wrote:

> 
> > 
> > Is available at
> > http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commit;h=3a911a216742e4ab998f3281409d46a62f252716
> > 
> > 
> > Please let me know, should I need to resend this patch for :
> > 1. git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> > OR
> > 2. git kernel.org:/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> How much testing has this seen on what range of cards and on what 
> architectures? I'd like some success stories from people using this patch.
> Is Debian shipping it?
> 
Not at this time.  AFAIK Ben Hutchings has tested that patch, although I
don't know on what hardware, and if he got other testers.  Ben?

> Its do think firmware patches are stupid (I do), but I'm not against 
> applying them if they are proven working.
> 
Cheers,
Julien
