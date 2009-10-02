Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZJBP6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZJBP6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZJBP6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:58:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:46733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZJBP6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:58:03 -0400
Date: Fri, 2 Oct 2009 17:58:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Adrian Ulrich <kernel@blinkenlights.ch>,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>
Subject: Re: [Bug #13935] 2.6.31-rcX breaks Apple MightyMouse (Bluetooth
 version)
In-Reply-To: <COE24pZSBH.A.DPD.fOTxKB@chimera>
Message-ID: <alpine.LSU.2.00.0910021757390.10941@wotan.suse.de>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.DPD.fOTxKB@chimera>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
> Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
> Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
> Date		: 2009-08-08 22:08 (55 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343

Fixed now in Linus' tree (42960a13) and submitted for stable. Please 
close.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
