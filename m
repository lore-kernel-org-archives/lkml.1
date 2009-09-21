Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZIULPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZIULPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZIULPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:15:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:52877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZIULPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:15:17 -0400
Date: Mon, 21 Sep 2009 13:15:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trivial: fix typos "enalbe" -> "enable"
In-Reply-To: <20090921093019.GB26665@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0909211315010.17028@wotan.suse.de>
References: <1253522362-22856-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LNX.2.00.0909211118340.17028@wotan.suse.de> <20090921093019.GB26665@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-37507419-1253531720=:17028"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-37507419-1253531720=:17028
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 21 Sep 2009, Uwe Kleine-König wrote:

> > This fix is not really correct -- the sentence doesn't have too much sense 
> > even after the typo fix.
> > Plus, it has been already fixed in a proper way, please see 
> > http://git.kernel.org/?p=linux/kernel/git/jikos/trivial.git;a=commitdiff;h=d5dd245f15b243b313df044741c0ba8065b0bc91
> ah, OK.
> 
> should I repost the remaining hunk or do you do that?

I have applied the aic7xxx_core.c hunk. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-37507419-1253531720=:17028--
