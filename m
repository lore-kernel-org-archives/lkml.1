Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZIATrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZIATrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZIATrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:47:15 -0400
Received: from claw.goop.org ([74.207.240.146]:46520 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZIATrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:47:15 -0400
Message-ID: <4A9D7A44.2000800@goop.org>
Date: Tue, 01 Sep 2009 12:47:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14062] Failure to boot as xen guest
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.qRG.usGlKB@chimera>
In-Reply-To: <_yaHeGjHEzG.A.qRG.usGlKB@chimera>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 13:34, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>   

I think this is fixed by d560bc61.

    J

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14062
> Subject		: Failure to boot as xen guest
> Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> Date		: 2009-08-25 15:48 (1 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=83b519e8b9572c319c8e0c615ee5dd7272856090
> References	: http://marc.info/?l=linux-kernel&m=125121534229538&w=4
> Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>
> Patch		: http://patchwork.kernel.org/patch/43799/
>
>
>   

