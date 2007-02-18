Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXBRQ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXBRQ4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXBRQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:56:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:41568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXBRQ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:56:09 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: [PATCH] i386 make NMI use PERFCTR1 for architectural perfmon
Date: Sun, 18 Feb 2007 17:56:05 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070217160656.GA16715@frankl.hpl.hp.com>
In-Reply-To: <20070217160656.GA16715@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181756.05672.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 17:06, Stephane Eranian wrote:
> Hello,
> 
> This patch against 2.6.20 

Please always submit against mainline:

patching file arch/i386/kernel/nmi.c
Hunk #1 FAILED at 288.
Hunk #2 succeeded at 740 (offset 55 lines).
Hunk #3 succeeded at 1017 with fuzz 1 (offset 59 lines).
1 out of 3 hunks FAILED -- rejects in file arch/i386/kernel/nmi.c
Patch patches/i386-make-nmi-use-perfctr1-for-architectural-perfmon does not apply (enforce with -f)


-Andi
