Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYGJUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYGJUoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYGJUoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:44:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43305 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYGJUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:44:08 -0400
Date: Thu, 10 Jul 2008 13:42:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for
 AMD IOMMU
Message-Id: <20080710134251.b2591ea8.randy.dunlap@oracle.com>
In-Reply-To: <20080710062603.GB23054@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
	<20080709185634.08c60937.akpm@linux-foundation.org>
	<20080710132447T.fujita.tomonori@lab.ntt.co.jp>
	<20080709213907.1e8b253b.akpm@linux-foundation.org>
	<20080710062603.GB23054@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 08:26:03 +0200 Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 10 Jul 2008 13:25:23 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > I have one related question, we should document all the kernel boot
> > > parameters in Documentation/kernel-parameters.txt?
> > > 
> > > Some of x86_64 boot parameters are in
> > > Documentations/x86/x86_64/boot-options.txt. The parameters of IOMMUs
> > > are scattered. It's confusing.
> > 
> > A single monolithic file has advantages.  I think I'd prefer that 
> > personally.  I'd forgotten that the x86-specific one exists, actually.
> 
> yeah, it should be all in Documentation/kernel-parameters.txt.

Agreed.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
