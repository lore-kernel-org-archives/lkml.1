Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZL3GWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZL3GWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZL3GWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:22:52 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:33898 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZL3GWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:22:51 -0500
Message-ID: <4B3AF1A7.60705@xenontk.org>
Date: Wed, 30 Dec 2009 11:52:31 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.UwB.PwhOLB@chimera>
In-Reply-To: <srmJ8vMxKPH.A.UwB.PwhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 08:58 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
> Subject		: i915: Commit 0e442c60 causes flickering
> Submitter	: David John <davidjon@xenontk.org>
> Date		: 2009-12-09 17:26 (21 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> 
> 
> 

This regression along with the associated one:
http://marc.info/?l=linux-kernel&m=126044443222694&w=2 is still present
in 2.6.33-rc2.

Regards,
David.
