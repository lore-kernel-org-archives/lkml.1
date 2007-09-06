Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXIFATe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXIFATe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 20:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXIFATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 20:19:25 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3987 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbXIFATY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 20:19:24 -0400
Date: Wed, 5 Sep 2007 20:17:31 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Patrick McHardy <kaber@trash.net>,
       adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal netfilter socket option removal
Message-ID: <20070906001731.GB28245@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org> <46DEC9BF.9010807@trash.net> <1189008806.10802.150.camel@localhost.localdomain> <20070905170831.GA25050@hmsreliant.think-freely.org> <1189014097.10802.174.camel@localhost.localdomain> <20070905192744.GB25050@hmsreliant.think-freely.org> <1189028351.12261.166.camel@jcmlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189028351.12261.166.camel@jcmlaptop>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 05:39:11PM -0400, Jon Masters wrote:
> On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:
> 
> > Now, I suppose its possible that I've not been looking at the right source tree
> > when doing my work.  I've based my modprobe patch on this git tree:
> > http://git.kernel.org/?p=linux/kernel/git/kyle/module-init-tools.git;a=summary
> > If theres a newer one, if you could please point it out to me, I'd appreciate
> > it.  If the functional equivalent of my second patch is already in there, then
> > we just need my first patch to be good to go.
> 
> Neil, please test:
> 
> http://www.kernel.org/pub/linux/kernel/people/jcm/module-init-tools/module-init-tools-3.3-pre12.tar.bz2
> 
> Jon.
> 
I'll test it first thing in the AM.  Thanks!
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
