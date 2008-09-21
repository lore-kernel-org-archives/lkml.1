Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYIUVle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYIUVle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIUVl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:41:28 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:37781 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYIUVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:41:28 -0400
Message-ID: <34132.166.70.238.43.1222031265.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <7lIhZC4hCxE.A.q8G.g0q1IB@albercik>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
    <7lIhZC4hCxE.A.q8G.g0q1IB@albercik>
Date: Sun, 21 Sep 2008 15:07:45 -0600 (MDT)
Subject: Re: [Bug #11549] 2.6.27-rc5 acpi: EC Storm error message on bootup
From: jmerkey@wolfmountaingroup.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       jmerkey@wolfmountaingroup.com
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11549
> Subject		: 2.6.27-rc5 acpi: EC Storm error message on bootup
> Submitter	: <jmerkey@wolfmountaingroup.com>
> Date		: 2008-09-02 21:27 (20 days old)
> References	: http://marc.info/?l=linux-kernel&m=122039255517586&w=4
> Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch		: http://marc.info/?l=linux-kernel&m=122098180019264&w=4
>
>
>

This bug is corrected by Alexey's patch and has passed all regression tests.

Jeff

