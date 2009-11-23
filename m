Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZKWJZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZKWJZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZKWJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:25:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZKWJZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:25:10 -0500
Date: Mon, 23 Nov 2009 10:25:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH TRIVIAL] atmel_lcdfb.c: Fix sinfo->irqbase from %lu to 
  %d in dev_info().
In-Reply-To: <4B0A4813.7060305@evidence.eu.com>
Message-ID: <alpine.LSU.2.00.0911231023140.6953@wotan.suse.de>
References: <1255083621-25147-1-git-send-email-nicolas.ferre@atmel.com> <alpine.LSU.2.00.0910091730560.19284@wotan.suse.de> <4B0A4813.7060305@evidence.eu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Claudio Scordino wrote:

>    may I ask you the current status of this patch ? I noticed that it
> has not been merged, yet.
> 
> Do we have any idea when it will be done ?
> 
> Since it is a trivial fix, I think it should be merged before the
> release of v2.6.32 (i.e., waiting the next merge window does not make
> much sense for such a trivial fix...).

I usually don't send pull requests for trivial queue to Linus more than 
once per release cycle.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
