Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0BBAEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:04:55 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:38719 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0BBAEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UHm4EqrmLSC2JyU67cvE+Xts2hPjldxRUI/OvzwQHKOFyodI6VAepp6l9dAY0KRrdD
         DYlosZUu+SMRmlxjU/D91XrZIHw6IKeVK8iizufveg9YZnuRnZzDv6FomRiZffCzjEUn
         qTzNIfeLryQjJWv8KE3irn4DwFucnEydnFYJk=
Subject: Re: [Bug #15198] Radeon KMS regression
From: Kevin Winchester <kjwinchester@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <d3IDKWHT5gE.A.UoB.P7hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.UoB.P7hZLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 20:04:50 -0400
Message-ID: <1265069090.1515.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15198
> Subject		: Radeon KMS regression
> Submitter	: Kevin Winchester <kjwinchester@gmail.com>
> Date		: 2010-01-30 17:18 (2 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42590a75019a50012f25a962246498dead428433
> References	: http://marc.info/?l=linux-kernel&m=126487191019612&w=4
> Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Patch		: http://patchwork.kernel.org/patch/75023/
> 
> 

This is fixed by the patch from FUJITA Tomonori - I just confirmed with
my latest build of Linus' tree (which has the patch).

Thanks,

-- 
Kevin Winchester


