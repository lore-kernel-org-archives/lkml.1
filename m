Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYFIIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYFIIYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYFIIYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:24:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37747 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbYFIIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:24:14 -0400
Message-ID: <484CE85C.1000201@jp.fujitsu.com>
Date: Mon, 09 Jun 2008 17:22:52 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10787] pcie hotplug bootup crash fix
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.VoD.Y3vSIB@albercik>
In-Reply-To: <dCRO4tbfLzK.A.VoD.Y3vSIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fixed (workaround for now) in 2.6.26-rc5.

Thanks,
Kenji Kaneshige


Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10787
> Subject		: pcie hotplug bootup crash fix
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2008-05-24 16:58 (15 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121164842212038&amp;w=4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


