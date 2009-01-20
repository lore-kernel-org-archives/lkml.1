Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZATAkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZATAkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZATAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:39:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:50554 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZATAj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KiSX/B1AbgN9OVkQIL38AVOe1jUU6JqC/4o/AAXJtDceDsgWjDDGx3rPr3TYu9oUhf
         GzXF3E/8j5n/iH4eIA+X0W1LPfNiliYUcg3BWQ1UYTohPK93Vp7gnHfQD/2/RuSW30WX
         k6+4txnFKv/thuop6DXOU9OE7A26DyMgePvw4=
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Daniel Drake <dsd@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Phil Dibowitz <phil@ipom.com>
In-Reply-To: <2QN7KFic7LG.A.pF.59QdJB@chimera>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
	 <2QN7KFic7LG.A.pF.59QdJB@chimera>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 16:39:43 -0800
Message-Id: <1232411983.5793.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 22:32 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12422
> Subject		: 2.6.28-git can't resume from str
> Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
> Date		: 2009-01-10 1:39 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> References	: http://marc.info/?l=linux-kernel&m=123155157909282&w=4
> 		  http://marc.info/?l=linux-kernel&m=123167815028388&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://lkml.org/lkml/2009/1/13/144
> 

The above referenced patch fixes STR for me.

Tested-by: Harvey Harrison <harvey.harrison@gmail.com>


