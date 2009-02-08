Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZBHWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZBHWHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZBHWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:07:08 -0500
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:38486 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbZBHWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:07:07 -0500
Message-ID: <498F5785.3000009@numericable.fr>
Date: Sun, 08 Feb 2009 23:07:01 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.HiF.r20jJB@chimera>
In-Reply-To: <sWhNs83kKPE.A.HiF.r20jJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
> Subject		: [Suspend regression][DRM, RADEON]
> Submitter	: etienne <etienne.basset@numericable.fr>
> Date		: 2009-01-28 22:00 (12 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
>
>
>   
hello,
yes it's still present in -rc4
But I noticed that when I switch off KDE4.2 desktop effects, suspend to 
ram is 100% reliable with 2.6.29-rc4
With 2.6.28, STR is 100% reliable with or without desktop effects

hope this helps,
Etienne







