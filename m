Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZL2Pme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZL2Pme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZL2Pmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:42:32 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47885 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZL2Pm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jhsz5dyb3Ptb0v8c1KHxular03hkwiPYbpc1f8StRMpVGk+rl5j4SBj6s5BpcyIA4g
         STM7Gke6ip8OKWxmMh9U36qfy6hGCDwPCt3c5RTVLHeVuQYGX6L8wFfFZL5l4AQqWEwb
         8tarn/0ra4fmnEgWVZvXS1lUoHEXB7yfkswqs=
Message-ID: <4B3A235E.2020908@lwfinger.net>
Date: Tue, 29 Dec 2009 09:42:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14538] Unable to associate with AP after resume since 2.6.32-rc6
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.pSE.3xhOLB@chimera>
In-Reply-To: <srmJ8vMxKPH.A.pSE.3xhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 09:28 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14538
> Subject		: Unable to associate with AP after resume since 2.6.32-rc6
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2009-11-03 22:07 (57 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d50bae33d1358b909ade05ae121d83d3a60ab63f

The patch to fix this bug has been sent to GregKH for inclusion in 2.6.32.Y and
the Bug is changed to "RESOLVED".

Larry
