Return-Path: <linux-kernel-owner+w=401wt.eu-S965712AbXBHK0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbXBHK0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 05:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXBHK0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 05:26:33 -0500
Received: from lazybastard.de ([212.112.238.170]:47131 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965712AbXBHK0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 05:26:32 -0500
Date: Thu, 8 Feb 2007 09:44:40 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070208094440.GA16344@lazybastard.org>
References: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <45C89BC1.9010703@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C89BC1.9010703@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 February 2007 10:16:17 -0500, Mark Lord wrote:
> 
> That interface is driven entirely backwards.
> The funtionality option should always be visible,

You are absolutely correct.  The _interface_ is horrible.  And changing
the config language won't change that fact one bit.

Make *config is broken, not the Kconfig files underneith.

Jörn

-- 
Joern's library part 13:
http://www.chip-architect.com/
