Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbXLTBIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbXLTBIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXLTBIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:08:25 -0500
Received: from 225.sub-75-208-182.myvzw.com ([75.208.182.225]:53530 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753782AbXLTBIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:08:24 -0500
Message-Id: <20071219223534.129042140@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 14:35:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's another round of the pagetable unification patches.  I've done a
few dozen rounds of randconfig builds on both 32- and 64-bit, so I hope
that will prevent compile problems in your test environment.

I've also boot-tested 64-bit and 32-bit PAE/non-PAE configs (both paravirt
and non-paravirt).

Thanks,
	J
-- 

