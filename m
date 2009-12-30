Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZL3K2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZL3K2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 05:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZL3K2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 05:28:16 -0500
Received: from wsp.xs4all.nl ([80.101.25.214]:56415 "EHLO wsprwl.xs4all.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325AbZL3K2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 05:28:15 -0500
Message-ID: <4B3B2B3D.40204@xs4all.nl>
Date: Wed, 30 Dec 2009 11:28:13 +0100
From: Ruud Linders <kernelml@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14910] Stable version 2.6.32.2 broke my KMS Radeon setup
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.oNH.TnhOLB@chimera>
In-Reply-To: <NJVdobuNFNK.A.oNH.TnhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 04:09 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14910
> Subject		: Stable version 2.6.32.2 broke my KMS Radeon setup
> Submitter	: Ruud Linders <kernelml@xs4all.nl>
> Date		: 2009-12-20 12:02 (10 days old)
> References	: http://marc.info/?l=linux-kernel&m=126131105608871&w=4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This one can be closed as it's not an 2.6.33 issue  (I'm running
2.6.33-rc1 with KMS just fine)

See also  http://patchwork.kernel.org/patch/69076/ for stable patch to
fix it in 2.6.32.3.



