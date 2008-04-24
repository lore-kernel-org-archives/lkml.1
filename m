Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYDXVJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYDXVJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYDXVJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:09:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:32895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYDXVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:09:36 -0400
Date: Thu, 24 Apr 2008 14:08:21 -0700
From: Brandon Philips <bphilips@suse.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Matthias Schwarzott <zzam@gentoo.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] no help text for DVB_TUNER_ITD1000
Message-ID: <20080424210821.GA14416@plankton>
References: <20080424202257.GC18854@cs181133002.pp.htv.fi> <20080424172838.5df1da67@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424172838.5df1da67@gaivota>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:28 Thu 24 Apr 2008, Mauro Carvalho Chehab wrote:
> On Thu, 24 Apr 2008 23:22:57 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> > The DVB_TUNER_ITD1000 option introduced by
> > commit 1881ee89e0fe03ac5bba9045acb3bea1818f9466
> > (V4L/DVB (7571): mt312: Cleanup buffer variables of read/write functions)
> > lacks a help text.
> > 
> > Please add a help text.
> 
> Thanks for pointing.
> 
> I just noticed and prepared a patch. I should soon add it to devel branch
> at -git for people to review. 

How is adding this Kconfig related to the patch that Matthias posted?
Once again, some very strange folding is happening as things are moving
into git.

http://article.gmane.org/gmane.linux.drivers.dvb/41017/match=mt312+cleanup+buffer+variables+read+write+functions

vs.

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1881ee89e0fe03ac5bba9045acb3bea1818f9466;hp=dbad108bdcb30629c850f5606949510da010a686

Could I take a look at the scripts that are used to generate the git
tree?  This is the second time in the last few weeks that something like
this has happened.

Cheers,

	Brandon
