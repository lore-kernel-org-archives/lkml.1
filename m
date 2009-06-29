Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZF2K3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZF2K3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZF2K3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:29:11 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:45921 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZF2K3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:29:10 -0400
Message-ID: <4A489775.6020102@numericable.fr>
Date: Mon, 29 Jun 2009 12:29:09 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.RvE.BjASKB@chimera>
In-Reply-To: <5Hhc7UkUKEO.A.RvE.BjASKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13663
> Subject		: suspend to ram regression (IDE related)
> Submitter	: Etienne Basset <etienne.basset@numericable.fr>
> Date		: 2009-06-26 17:40 (3 days old)
> References	: http://lkml.org/lkml/2009/6/26/242
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/32719/
> 
> 
> 
yes, patch is not yet upstream;
2.6.31-rc1 + bart patch resumes from STR
current git + bart patch resume from STR fails, STR seems to have been broken again
(i was confident that the post-rc1 MCE fixes would correct the fact that computer hangs
 a few minutes after resume, but computer doesn't resume at all)


Etienne
