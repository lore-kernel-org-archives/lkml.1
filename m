Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXBJVHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXBJVHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXBJVHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:07:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXBJVHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:07:54 -0500
Date: Sat, 10 Feb 2007 13:06:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: caglar@pardus.org.tr
Cc: lkml <linux-kernel@vger.kernel.org>, avi@qumranet.com, mingo@elte.hu,
       stable@kernel.org
Subject: Re: + kvm-fix-asm-constraint-for-lldt-instruction.patch added to
 -mm tree
Message-Id: <20070210130606.393ed586.akpm@linux-foundation.org>
In-Reply-To: <200702101932.30623.caglar@pardus.org.tr>
References: <200701310036.l0V0abnE002548@shell0.pdx.osdl.net>
	<200702101932.30623.caglar@pardus.org.tr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 19:32:30 +0200 "S.Çağlar Onur" <caglar@pardus.org.tr> wrote:

> Hi;
> 
> 31 Oca 2007 Çar tarihinde, akpm@osdl.org şunları yazmıştı: 
> > The patch titled
> >      kvm: Fix asm constraint for lldt instruction
> >  has been added to the -mmtree.  Its filename is
> >      kvm-fix-asm-constraint-for-lldt-instruction.patch
> 
> Is it possible to merge it into .20.1, its really trivial and its the only 
> compile fix for gcc-4.2.x?
> 

OK by be.  Avi?
