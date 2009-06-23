Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZFWIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZFWIse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZFWIs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:48:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZFWIsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:48:25 -0400
Date: Tue, 23 Jun 2009 10:48:28 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: adding __init/__exit macros to DAC960.c
In-Reply-To: <200906230004.36995.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0906231048070.7457@wotan.suse.de>
References: <200906121307.29865.PeterHuewe@gmx.de> <200906230004.36995.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1491735369-1245746908=:7457"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1491735369-1245746908=:7457
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 23 Jun 2009, Peter Hüwe wrote:

> > Trivial patch which adds the __init and __exit macros to the module_init /
> > module_exit functions from drivers/block/DAC960.c
> > linux version 2.6.30
> I was wondering if there is anything wrong with the patch or is it still in 
> the review phase ?

I have applied it to trivial queue, thanks Peter.

-- 
Jiri Kosina
SUSE Labs

--168427776-1491735369-1245746908=:7457--
