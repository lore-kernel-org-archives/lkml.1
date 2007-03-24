Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbXCXQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbXCXQgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXCXQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:36:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59337 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbXCXQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:36:53 -0400
Date: Sat, 24 Mar 2007 09:35:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Boris Andratzek <Boris.Andratzek@cation.de>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>
Subject: Re: troubles with DAC960
Message-Id: <20070324093554.89cee415.randy.dunlap@oracle.com>
In-Reply-To: <460533DC.3010006@cation.de>
References: <4602C062.6050406@cation.de>
	<460533DC.3010006@cation.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 15:21:16 +0100 Boris Andratzek wrote:

> Boris Andratzek wrote:
> > Hello members of the kernel-list,
> > 
> > 
> > I'm new to this and hope I don't misuse the list in any way.
> > 
> > Doing the update from debian sarge to etch on my server I ran into the
> > bug documented here: bugzilla.kernel.org/show_bug.cgi?id=7177
> > I already made some comments there. I tried to contact the maintainer of
> > the DAC960 driver but as far as I found out, Leonard N. Zubkoff
> > unfortunatly died in a helicopter crash.
> > 
> > Without being impious, I want to ask if anybody can give me an idea of
> > how this thing will go on. Is there anybody new doing the maintaining?
> > Is there hope for a fix? Where can I find more information? Can I do
> > anything to help (testing, logging)?
> > 
> > regards,
> > 
> > Boris Andratzek
> > 
> 
> Hello!?
> 
> I didn't catch no reaction at all, so I am not sure if I sent my
> question the right way! Could anybody respond, please, even without an
> idea of solving my problem!?
> 
> Thanks,

There is no current DAC960 maintainer.

I'd try asking on the linux-scsi mailing list (cc-ed there).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
