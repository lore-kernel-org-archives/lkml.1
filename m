Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0BKCs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:48:29 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:33806 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0BKCs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:48:27 -0500
Message-ID: <4B736FD3.2000707@xenontk.org>
Date: Thu, 11 Feb 2010 08:17:47 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid
 context
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <iuJeop2ribM.A.DgH.XY1bLB@chimera>
In-Reply-To: <iuJeop2ribM.A.DgH.XY1bLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2010 05:58 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> Subject		: Bluetooth: sleeping function called from invalid context
> Submitter	: David John <davidjon@xenontk.org>
> Date		: 2010-01-12 9:19 (27 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/9e726b17422bade75fba94e625cd35fd1353e682
> References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> Handled-By	: Marcel Holtmann <marcel@holtmann.org>
> Patch		: http://patchwork.kernel.org/patch/76019/
> 
> 
> 

Hi Rafael,

This bug is now fixed by the upstream commit 485f1e ("Bluetooth: Fix
sleeping function in RFCOMM within invalid context") and can be closed.

Thanks,
David.
