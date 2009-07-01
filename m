Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZGAI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZGAI6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZGAI6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:58:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:41533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZGAI6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:58:44 -0400
Date: Wed, 1 Jul 2009 10:58:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: adding __init/__exit macros to DAC960.c
In-Reply-To: <200907011054.59988.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0907011057570.4994@wotan.suse.de>
References: <200906121307.29865.PeterHuewe@gmx.de> <200906230004.36995.PeterHuewe@gmx.de> <alpine.LNX.2.00.0906231048070.7457@wotan.suse.de> <200907011054.59988.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-618679282-1246438727=:4994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-618679282-1246438727=:4994
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Jul 2009, Peter Hüwe wrote:

> > > > Trivial patch which adds the __init and __exit macros to the 
> > > > module_init / module_exit functions from drivers/block/DAC960.c 
> > > > linux version 2.6.30
> > > I was wondering if there is anything wrong with the patch or is it still
> > > in the review phase ?
> > I have applied it to trivial queue, thanks Peter.
> I just looked in your git tree - it still does not appear there :)
> I'm sorry for bugging you with this trivial patch.

Hi Peter,

I guess you looked into the wrong branch -- it is in 'for-next' branch, 
see 
http://git.kernel.org/?p=linux/kernel/git/jikos/trivial.git;a=commit;h=ef59a28cbb29dd6ec4fcd59eaacb15ea85adbd2e

-- 
Jiri Kosina
SUSE Labs
--168427776-618679282-1246438727=:4994--
