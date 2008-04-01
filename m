Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYDABCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYDABCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYDABCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:02:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:41603 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbYDABCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:02:15 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20080331235150.GA10593@kroah.com>
References: <20080330184259.GB21375@atjola.homenet>
	 <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
	 <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com>
	 <20080331135653.ZZRA012@mailhub.coreip.homeip.net>
	 <alpine.LFD.1.00.0803311122040.14670@woody.linux-foundation.org>
	 <1207005164.10388.172.camel@pasglop>  <20080331235150.GA10593@kroah.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 12:01:15 +1100
Message-Id: <1207011675.10388.189.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-31 at 16:51 -0700, Greg KH wrote:
> 
> Can you try it with the patch that was just posted by Dmitry for the
> evdev code?

Yup, it works, ship it ! :-)

Cheers,
Ben.


