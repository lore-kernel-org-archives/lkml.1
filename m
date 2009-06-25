Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZFYPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZFYPIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZFYPH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:07:56 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:44556 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFYPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:07:55 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jan Scholz" <scholz@fias.uni-frankfurt.de>
Subject: Re: [Bug #13407] adb trackpad disappears after suspend to ram
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.Q3G.MZ7KKB@chimera>
Date: Thu, 25 Jun 2009 17:07:49 +0200
In-Reply-To: <D9VoutSOyXP.A.Q3G.MZ7KKB@chimera> (Rafael J. Wysocki's message
	of "Sun, 7 Jun 2009 11:52:55 +0200 (CEST)")
Message-ID: <87bpocqrlm.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is still present in v2.6.31-rc1

Cheers,
   Jan

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
> Subject		: adb trackpad disappears after suspend to ram
> Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
> Date		: 2009-05-28 7:59 (11 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
> References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
>
