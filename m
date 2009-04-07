Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZDGMfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZDGMfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZDGMey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:34:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:56014 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZDGMey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:34:54 -0400
Date: Tue, 7 Apr 2009 14:34:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final set of SCSI updates for the merge window
In-Reply-To: <1239033266.3641.9.camel@mulgrave>
Message-ID: <alpine.LRH.2.00.0904071433440.27739@twin.jikos.cz>
References: <1239033266.3641.9.camel@mulgrave>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, James Bottomley wrote:

> Adrian Bunk (3):
[ ... ]
>       ses: #if 0 the unused ses_match_host()

I never understood why should we "#if 0" unused code in mainline tree 
rather just removing it unless it has real users?

-- 
Jiri Kosina
SUSE Labs

