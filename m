Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZDGEJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZDGEJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZDGEJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:09:40 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:28563 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZDGEJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:09:39 -0400
Date: Tue, 07 Apr 2009 00:09:19 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Bug #12908] acpi_ex_extract_from_field -- div by zero
In-reply-to: <AsKNxFx2juN.A.l9H.UGn2JB@chimera>
Message-id: <alpine.LFD.2.00.0904070008140.5698@localhost.localdomain>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
 <AsKNxFx2juN.A.l9H.UGn2JB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12908
> Subject		: acpi_ex_extract_from_field -- div by zero
> Submitter	: Jiri Slaby <jirislaby@gmail.com>
> Date		: 2009-03-15 10:47 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=123711408225013&w=4
> Handled-By	: Lin Ming <ming.m.lin@intel.com>

This is unreproducible and now marked closed.
The theory is that somebody (else:-) scribbled on random kernel memory...

thanks,
Len Brown, Intel Open Source Technology Center

