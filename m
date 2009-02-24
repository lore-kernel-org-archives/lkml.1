Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZBXKGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZBXKGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 05:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZBXKGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 05:06:39 -0500
Received: from www.tglx.de ([62.245.132.106]:55397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbZBXKGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 05:06:38 -0500
Date: Tue, 24 Feb 2009 11:03:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michal Suchanek <hramrach@centrum.cz>, Stable Team <stable@kernel.org>
Subject: Re: [Bug #12393] debugging in dosemu causes lots of 'scheduling
 while atomic'
In-Reply-To: <LLno3yT_fnC.A.dl.6zzoJB@chimera>
Message-ID: <alpine.LFD.2.00.0902241101580.3523@localhost.localdomain>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.dl.6zzoJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12393
> Subject		: debugging in dosemu causes lots of 'scheduling while atomic'
> Submitter	: Michal Suchanek <hramrach@centrum.cz>
> Date		: 2009-01-09 07:28 (46 days old)
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> Patch		: http://lkml.org/lkml/2009/1/13/445

Commit be716615fe596ee117292dc615e95f707fb67fd1 in Linus tree.

"Cc: stable@kernel.org" is in the commit log, so stable folks should
have it as well.

Thanks,

	tglx
