Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZLRJrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZLRJrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZLRJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:47:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:55016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbZLRJrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:47:45 -0500
Message-ID: <4B2B4F72.4050301@kernel.org>
Date: Fri, 18 Dec 2009 01:46:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] x86: early_res range bootmem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches regarding with early_res and bootmem

and last one will make use early_res instead of bootmem with x86 64bits

the first two are needed for some amd_bus.c/intel_bus.c cleaning up patches too.
maybe you could those to in tip x86_pci and ask Jesse to pull those two into pci next.
and then I will send other amd_bus.c/intel_bus.c clean patches to Jesse with updated comments. 

Thanks

Yinghai

