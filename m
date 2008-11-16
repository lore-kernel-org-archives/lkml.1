Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYKPVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYKPVlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYKPVlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:41:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:54854 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYKPVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E95acGinLRqtR2zpCzREuJvoB6YOdPZ9tQQlBbMFIMZg7VU4j+nUOgCVjXjCwssMMU
         WeUpdVdJtTa1jk56Df8rnqYKFiXcZkA8DEra30NiM5e/CXnVhVoE5ahvwXurD07DMCfn
         hahM9QVHe9BZ57ffdy8qYXmamT/wf2UI1Dkfs=
Message-ID: <49209366.3060500@gmail.com>
Date: Sun, 16 Nov 2008 23:40:54 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.28-rc5: Reported regressions from 2.6.27
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to note, here on acer aspire one suspend to disk is broken too.
System suspends, and then hangs.

If I shutdown the system, and then attempt resume, it resumes, and then hangs.

Best regards,
	Maxim Levitsky
