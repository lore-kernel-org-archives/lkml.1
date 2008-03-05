Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYCEDDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYCEDDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 22:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYCEDDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 22:03:13 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58142 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYCEDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 22:03:12 -0500
To: rubisher@scarlet.be
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, kyle@mcmartin.ca,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <JX7RR7$3528E2939A349F65E12E3F27315EEC50@scarlet.be>
References: <JX7RR7$3528E2939A349F65E12E3F27315EEC50@scarlet.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080305115641Q.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 05 Mar 2008 11:56:41 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Mar 2008 17:13:55 +0100
"rubisher" <rubisher@scarlet.be> wrote:

> [snip]
> > > Can you try the following patch? It's on the top of the patchset.
> > > 
> > Good catch: now this first testing system (I mean the b2k) is up and running ;-)
> > 
> > I will now try the ccio_dma driver on a d380 ...
> > 
> Yes, it works too on a d380 boxe running a 32bit up kernel.

Great, thanks a lot for testing both IOMMUs!


> Btw (it was a long time ago), I also resurrect my 64 config for the b2k model
> and it also works fine.

Nice, and sorry about the bug on 32bits boxes.

Thanks again,
