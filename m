Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZCODgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZCODgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZCODf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:35:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59918 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZCODf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AbTAL7SgNX+SSgI6kvyShmhNekPv2fI8+0eMShrVZh3IU+K9lPaXqgMJePaqH47VCV
         /vxi8SP43YUygR0fv+Dp6aN0zgrWl4sEJ5EdJXl5DLQGVmbLQkZrAD9Z4O3eMTl3dQs+
         2zC1uzxDw2gNE8YwNsalOYLh18KJ1JycYUAaE=
Subject: Re: [Bug #12806] i915 broken STR
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <GCLaknAim2M.A.LaD.u4BvJB@chimera>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <GCLaknAim2M.A.LaD.u4BvJB@chimera>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:35:54 -0700
Message-Id: <1237088154.4064.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 20:05 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12806
> Subject		: i915 broken STR
> Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
> Date		: 2009-02-28 4:20 (15 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5669fcacc58bf3a7386057addffd280d75380858
> References	: http://marc.info/?l=linux-kernel&m=123579487801064&w=4
> 
> 

You can close this, turns out KMS got enabled in my config and userspace
was too old to cope.

Harvey

