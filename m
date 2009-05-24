Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZEXWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZEXWxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZEXWxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:53:05 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:55795
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZEXWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:53:04 -0400
Date: Mon, 25 May 2009 07:53:02 +0900
From: Mattia Dongili <malattia@linux.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       fanderay <fanderay4@googlemail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13148] resume after suspend-to-ram broken on Sony Vaio
	VGN-SR19VN when sony-laptop driver present
Message-ID: <20090524225302.GA3566@kamineko.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.VwB.v-bGKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uSztiUhmDDC.A.VwB.v-bGKB@chimera>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.30-rc7 x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 09:11:50PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13148
> Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN when sony-laptop driver present
> Submitter	: fanderay <fanderay4@googlemail.com>
> Date		: 2009-04-22 14:39 (33 days old)

sorry for not mentioning this before, but it looks like this regression
was introduced between .28 and .29

cheers
-- 
mattia
:wq!
