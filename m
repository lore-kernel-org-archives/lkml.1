Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYBAJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYBAJqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYBAJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:46:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYBAJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:46:11 -0500
Subject: Re: What's the status of x2APIC support in Linux kernel?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rijndael Cosque <rijcos@gmail.com>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 10:46:13 +0100
Message-Id: <1201859173.32654.38.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 16:43 +0800, Rijndael Cosque wrote:
> Hi all,
> 
> I found the x2APIC spec via http://www.intel.com/products/processor/manuals/.
> 
> Looks at present there is no x2APIC support in Linux kernel 2.6.24?
> 
> Is there any experimental patch available for Linux kernel? -- I
> googled "x2APIC Linux";  looks no patch for now?

I think SGI has an implementation hidden away somewhere, Mike?

