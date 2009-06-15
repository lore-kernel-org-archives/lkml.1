Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbZFOP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbZFOP4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFOP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:56:03 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:57471 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751528AbZFOP4B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:56:01 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 11:56:01 EDT
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R1805Mzz1202hzzz32i17ch6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KLAE74-01-36S-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cpumask: new cpumask operators for arch/x86/kernel/cpu/cpufreq/powernow-k8.c
Date: Mon, 15 Jun 2009 10:40:22 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273036209AC@sausexmb4.amd.com>
In-Reply-To: <200906122058.38112.rusty@rustcorp.com.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cpumask: new cpumask operators for arch/x86/kernel/cpu/cpufreq/powernow-k8.c
Thread-Index: AcnrUP+wKdJQ4FUkQNOkOr1dd3YXxQCfpN8g
References: <20090611225928.E6FF4DDDA1@ozlabs.org> <20090611232517.GA32486@redhat.com> <200906122058.38112.rusty@rustcorp.com.au>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, "Dave Jones" <davej@redhat.com>
CC: <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>
X-OriginalArrivalTime: 15 Jun 2009 15:40:23.0847 (UTC) FILETIME=[990BCB70:01C9EDCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove all old-style cpumask operators, and cpumask_t.
> 
> Also: get rid of the unused define_siblings function.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

I ran this over the weekend on a 24 core box without
any issues.  Please commit.

Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>

