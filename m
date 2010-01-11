Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853Ab0AKFWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab0AKFWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 00:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532Ab0AKFWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 00:22:23 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:59017 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0AKFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 00:22:23 -0500
Message-ID: <4B4AB589.7080004@xenontk.org>
Date: Mon, 11 Jan 2010 10:52:17 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.DAC.zglSLB@chimera>
In-Reply-To: <CXIfLt-ygXM.A.DAC.zglSLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 04:26 AM, Rafael J. Wysocki wrote:
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
> Date		: 2009-12-09 17:26 (33 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4
> 
> 
> 

Still present in 2.6.33-rc3.

Regards,
David.
