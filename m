Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZLKRiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZLKRiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZLKRiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:38:21 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:41496 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZLKRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:38:20 -0500
Date: Fri, 11 Dec 2009 09:37:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 11 (x86/mm/mmio-mod)
Message-Id: <20091211093755.5d7a273c.randy.dunlap@oracle.com>
In-Reply-To: <20091211160151.6b71078e.sfr@canb.auug.org.au>
References: <20091211160151.6b71078e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4B228390.00DB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 16:01:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091210:


arch/x86/mm/mmio-mod.c:100: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:106: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:110: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:123: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:129: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:131: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:286: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:305: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:367: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:404: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:406: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:426: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:428: warning: too many arguments for format


on both i386 and x86_64

---
~Randy
