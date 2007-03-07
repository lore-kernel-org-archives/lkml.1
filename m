Return-Path: <linux-kernel-owner+w=401wt.eu-S2992665AbXCGWca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992665AbXCGWca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992671AbXCGWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:32:30 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36926 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992665AbXCGWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:32:29 -0500
Message-ID: <45EF3C73.2020201@vmware.com>
Date: Wed, 07 Mar 2007 14:28:03 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	 <1173300032.24738.750.camel@localhost.localdomain>	 <45EF2991.1020204@goop.org>	 <1173303639.24738.814.camel@localhost.localdomain>	 <45EF2FFE.7010705@vmware.com>	 <1173305670.24738.849.camel@localhost.localdomain>	 <45EF39F3.8050506@vmware.com> <1173306713.24738.861.camel@localhost.localdomain>
In-Reply-To: <1173306713.24738.861.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 22:32:28.0573 (UTC) FILETIME=[7CDB54D0:01C76108]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 02:31 PM, Thomas Gleixner wrote:
> Please make these things self contained and not relying on whatever
> time_init_hook() contains.
> 

Fixing up the code to do this now....

thanks,
Dan
