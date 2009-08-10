Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZHJBa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZHJBa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 21:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZHJBa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 21:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZHJBaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 21:30:55 -0400
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 10 Aug 2009 11:31:05 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19071.30809.398179.900584@notabene.brown>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mike Snitzer" <snitzer@redhat.com>
Subject: Re: [Bug #13944] MD raid regression
In-Reply-To: message from Rafael J. Wysocki on Sunday August 9
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	<u1L1PAbl8zG.A.RyC.aj1fKB@chimera>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday August 9, rjw@sisk.pl wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).

Yes, it still should be listed.  The first patch didn't quite fix it.
A second one probably does.

Thanks.
NeilBrown

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
> Subject		: MD raid regression
> Submitter	: Mike Snitzer <snitzer@redhat.com>
> Date		: 2009-08-05 15:06 (5 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=449aad3e25358812c43afc60918c5ad3819488e7
> References	: http://marc.info/?l=linux-kernel&m=124948481218857&w=4
> Handled-By	: NeilBrown <neilb@suse.de>
> Patch		: http://patchwork.kernel.org/patch/39521/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
