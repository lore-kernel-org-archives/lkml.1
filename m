Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYLDTDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYLDTDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYLDTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:02:55 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:18626 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbYLDTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=JIuXgC4WPzW5k+B9tzW+ZFJOQgZHEq/SBgVlI5dHSgXCet65eVmt1DDIAaKSXDR720
         WIvxnSxniDN85/m57ymLhKlMPNXt57+7S3JyMQmUh5qFsAG/Cv6nWaLO2HmUYaZlJVGi
         99nFI2JAfNc2rbVdleJqwPgjTTcjKgNJPBsfI=
Date: Thu, 4 Dec 2008 21:02:34 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [Bug #12154] Mmiotrace regression in 2.6.28-rc6
Message-ID: <20081204210234.4c9971aa@daedalus.pq.iki.fi>
In-Reply-To: <bfPM5B8Tx2B.A.RWH.1oxNJB@chimera>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	<bfPM5B8Tx2B.A.RWH.1oxNJB@chimera>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2008 22:58:03 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12154
> Subject		: Mmiotrace regression in 2.6.28-rc6
> Submitter	: Pekka Paalanen <pq@iki.fi>
> Date		: 2008-11-23 13:41 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=122744774317151&w=4

This is fixed:

http://marc.info/?l=linux-kernel&m=122746837006707&w=2

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7ee1768ddb3075ae3a0801cc2d0ea4195530a7db

Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
