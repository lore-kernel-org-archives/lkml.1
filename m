Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366Ab0AZWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0AZWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235Ab0AZWpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:45:21 -0500
Received: from [150.254.222.82] ([150.254.222.82]:45562 "EHLO mail.pceuip.pl"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0AZWpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:45:19 -0500
X-Nat-Received: from [192.168.241.179]:47443 [ident-empty]
	by I DS proxy with TPROXY id 1264545904.23994
	abuse-to abuse(at)dsv.agh.edu.pl
Message-ID: <4B5F706B.60905@freesco.pl>
Date: Tue, 26 Jan 2010 23:44:59 +0100
From: Maciej Sitarz <macieks@freesco.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl-PL; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14748] e1000e NIC not working after reboot
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.JGB.haMXLB@chimera>
In-Reply-To: <q60Z28d_9yH.A.JGB.haMXLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -48.574
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.01.2010 23:22, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).

The problem still exist I'm using kernel version 2.6.32.6 now.

I have one more observation:
After the reboot, when the NIC is not working, both leds are on. Not 
blinking, they light all the time, even if I remove the plug.

Best regards
-- 
Maciek Sitarz
