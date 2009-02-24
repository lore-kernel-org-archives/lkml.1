Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZBXBEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZBXBEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZBXBD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:03:56 -0500
Received: from gw.goop.org ([64.81.55.164]:49620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZBXBDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:03:55 -0500
Message-ID: <49A34777.3050809@goop.org>
Date: Mon, 23 Feb 2009 17:03:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Tilman Schmidt <t.schmidt@phoenixsoftware.de>,
       Stable Kernel <stable@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12766] Lots of smp_processor_id() in preemptible messages
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.-rC.vozoJB@chimera>
In-Reply-To: <vP9hdyF4fL.A.-rC.vozoJB@chimera>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12766
> Subject		: Lots of smp_processor_id() in preemptible messages
> Submitter	: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
> Date		: 2009-02-23 18:37 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=123541536414019&w=4
>
>   

Looks like stable needs to pick up  
d85cf93da66977dbc645352be1b2084a659d8a0b.

    J
