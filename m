Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZHJAe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZHJAe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZHJAeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:34:25 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:49091 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZHJAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:34:23 -0400
X-VR-Score: -180.00
X-Authority-Analysis: v=1.0 c=1 a=eWuteZks3SYA:10 a=VwQbUJbxAAAA:8
 a=kviXuzpPAAAA:8 a=4szxcD0kUfCJCbDn5BQA:9 a=npz7Yl7QyozWqSkSTQlGW9z5g4AA:4
 a=4vB-4DCPJfMA:10
X-CM-Score: 0.00
From: Duncan <1i5t5.duncan@cox.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13869] Radeon framebuffer (w/o KMS) corruption at boot.
Date: Sun, 9 Aug 2009 17:10:28 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-382-gb687937; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.nZD.xj1fKB@chimera>
In-Reply-To: <u1L1PAbl8zG.A.nZD.xj1fKB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908091710.28486.1i5t5.duncan@cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009 13:44:24 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13869
> Subject		: Radeon framebuffer (w/o KMS) corruption at boot.
> Submitter	: Duncan <1i5t5.duncan@cox.net>
> Date		: 2009-07-29 16:44 (12 days old)

Yes, as of today's pull, it's still there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
