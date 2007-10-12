Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbXJLQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbXJLQd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbXJLQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:12:28 -0400
Received: from mail.suse.de ([195.135.220.2]:54189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760909AbXJLQM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:12:26 -0400
Date: Fri, 12 Oct 2007 18:12:23 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHes] ISDN simple cleanups - hotplug API prep
Message-ID: <20071012161223.GA31078@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>, kkeil@suse.de,
	isdn4linux@listserv.isdn4linux.de,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071011190655.GA23206@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011190655.GA23206@havoc.gtf.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 03:06:55PM -0400, Jeff Garzik wrote:
> Karsten,
> 
> As I mentioned in previous emails, I would like to send these upstream
> for 2.6.24.  These are the first step in converting the hisax driver
> over to the modular, hotplug-friendly ISA/PNP/PCI APIs.
> 
> The second step in that conversion is 95% complete (one more driver),
> and is stored in branch 'isdn-pci' of the repository below.
> 
> The changes below were posted as patches many weeks ago, without
> comment.  I also propagated these to the 'ALL' branch that gets copied
> into -mm for testing, though some changes have been there longer than
> others.
> 
> All these changes are code movement changes, without any changes to the
> logic -- even the existing whitespace funnies were kept in many cases.
> 
> Would you mind pulling these, or permitting me to push them upstream?
> 

Tested and Acked.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
