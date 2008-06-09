Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYFIIUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYFIIUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYFIIUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:20:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45751 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbYFIIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:20:30 -0400
Message-ID: <484CE793.2080609@jp.fujitsu.com>
Date: Mon, 09 Jun 2008 17:19:31 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Ryan Hope <rmh3093@gmail.com>
Subject: Re: [Bug #10760] PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.LGE.q3vSIB@albercik>
In-Reply-To: <dCRO4tbfLzK.A.LGE.q3vSIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this was fixed in 2.6.26-rc5. Could anyone please confirm it?
Unfortunately, I don't have the reproduction environment.

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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10760
> Subject		: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
> Submitter	: Ryan Hope <rmh3093@gmail.com>
> Date		: 2008-05-19 17:47 (20 days old)
> References	: http://marc.info/?l=linux-pci&amp;m=121121926401755&amp;w=2
> Handled-By	: Matthew Wilcox <matthew@wil.cx>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


