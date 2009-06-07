Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZFGPXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZFGPXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZFGPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:23:14 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61061 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZFGPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:23:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Message-id: <4A2BDB64.6020404@gmail.com>
Date: Sun, 07 Jun 2009 11:23:16 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre)
 Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yu Zhao <yu.zhao@intel.com>
Subject: Re: [Bug #13423] JMicron SATA controller not available
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
 <D9VoutSOyXP.A.2oG.IZ7KKB@chimera>
In-reply-to: <D9VoutSOyXP.A.2oG.IZ7KKB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2009 05:52 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13423
> Subject		: JMicron SATA controller not available
> Submitter	: Marc Dionne<marc.c.dionne@gmail.com>
> Date		: 2009-05-26 22:56 (13 days old)
> References	: http://lkml.org/lkml/2009/5/26/687
> Handled-By	: Yu Zhao<yu.zhao@intel.com>
> Patch		: http://lkml.org/lkml/2009/5/27/402

I verified that the bug is still there in mainline from this morning.

The fix is part of this pull request:
	http://lkml.org/lkml/2009/6/6/148
so hopefully it will make it in before the final release.

Marc
