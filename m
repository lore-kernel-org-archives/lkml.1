Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXCMNgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXCMNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933534AbXCMNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:36:47 -0400
Received: from ns.suse.de ([195.135.220.2]:36887 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367AbXCMNgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:36:46 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [1/6] 2.6.21-rc3: known regressions
Date: Tue, 13 Mar 2007 14:36:15 +0100
User-Agent: KMail/1.9.1
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313124957.GR18731@stusta.de> <45F6A240.3090601@drzeus.cx>
In-Reply-To: <45F6A240.3090601@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703131436.15586.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. März 2007 14:08 schrieb Pierre Ossman:
> Adrian Bunk wrote:
> > 
> > Subject    : mmc card reader no longer works
> > References : http://lkml.org/lkml/2007/2/27/91
> > Submitter  : Pavel Machek <pavel@ucw.cz>
> > Handled-By : Oliver Neukum <oneukum@suse.de>
> > Status     : unknown
> > 
> 
> First I heard of this. The error report is a bit thin so Pavel will need to
> elaborate a bit more.

The device is a USB serial device. USB serial was known to have issues
in the version this happened. As far as I know the bug has not been
replicated after this bugs were fixed.

	Regards
		Oliver
