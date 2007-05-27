Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXE0PgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXE0PgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbXE0PgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:36:11 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:56961 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXE0PgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:36:10 -0400
Date: Sun, 27 May 2007 16:35:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Message-ID: <20070527153553.GA19853@srcf.ucam.org>
References: <4658C807.9040005@tmr.com> <200705271253.03396.rjw@sisk.pl> <46597F37.5050107@tmr.com> <200705271506.45714.rjw@sisk.pl> <465984E5.10506@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465984E5.10506@tmr.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Documentation on /sys/power/resume
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 09:17:25AM -0400, Bill Davidsen wrote:

> Sounds like sispend2 is still needed, I haven't needed a suspending 
> kernel in a few years, and I was hoping that with suspend working in 
> mainline that resume would have been implemented. Sounds as if that's 
> not the case, my swap is RAID1, I was hoping to resume from one of the 
> mirrors, since they are based on a partition. No joy wit or without 
> /sys/power/resume, so I'll look further.

Should work absolutely fine as long as you set up the RAID before 
attempting to resume.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
