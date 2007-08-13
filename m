Return-Path: <linux-kernel-owner+w=401wt.eu-S1765432AbXHMWfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765432AbXHMWfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXHMWfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:35:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbXHMWfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:35:05 -0400
Date: Mon, 13 Aug 2007 17:09:56 -0400
From: Dave Jones <davej@redhat.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make -mm a more viable testbed (was: [PATCH] [1/12]
	x86: Work around mmio config space quirk on AMD)
Message-ID: <20070813210956.GA18334@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Zan Lynx <zlynx@acm.org>,
	Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
References: <200708130808.46989.a1426z@gawab.com> <1187037607.7855.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187037607.7855.21.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:40:06PM -0600, Zan Lynx wrote:
 > On Mon, 2007-08-13 at 08:08 +0300, Al Boldi wrote:
 > > Linus Torvalds wrote:
 > > > On Sun, 12 Aug 2007, Dave Jones wrote:
 > > > > 
 > > > > This does make me wonder, why these weren't caught in -mm ?
 > > > 
 > > > I'm worried that -mm isn't getting a lot of exposure these days. People do 
 > > > run it, but I wonder how many..
 > > 
 > > Well, I'm not running it because it's got too much garbage in it, which makes 
 > > it a pretty unrealistic testbed.  And to make matters worse, I also stay 
 > > away from rc's as a consequence.
 > > 
 > > To make -mm more viable, it may be advisable to restructure -mm in such a way 
 > > as to be a Kconfig option to mainline.  This would probably involve some 
 > > patch management functionality to apply experimental submissions on a 
 > > per-patch basis, as opposed to being a 'take it or leave it slam onto 
 > > mainline' patch.
 > 
 > I thought most people running -mm were running klive, which shou
 > ld tell kernel versions, uptime and other things.  I run it, anyway.
 > 
 > http://klive.cpushare.com/

If that's the case, there are 3 people running 2.6.23-rc2-mm2.
I suspect the actual number of users is considerably higher.
Somehow I doubt that 'most' people are running klive.

	Dave

-- 
http://www.codemonkey.org.uk
