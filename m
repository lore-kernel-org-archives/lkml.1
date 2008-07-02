Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYGBCuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYGBCuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYGBCuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:50:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962AbYGBCuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:50:12 -0400
Date: Tue, 1 Jul 2008 19:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alexisb@us.ibm.com, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
Message-Id: <20080701194840.258b500f.akpm@linux-foundation.org>
In-Reply-To: <20080702113711Y.fujita.tomonori@lab.ntt.co.jp>
References: <20080612172554X.fujita.tomonori@lab.ntt.co.jp>
	<1214949124.6553.9.camel@alexis>
	<20080702113711Y.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 11:37:27 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > http://marc.info/?l=linux-kernel&m=121329005131176&w=2
> > 
> > Are they at a state where they can be picked-up?  If not what is needed
> > to progress?
> 
> The updated patch to fix the Calgary IOMMU driver looks fine to
> me. Andrew, can you put it in the -mm?

umm, put what into -mm?  I see four different patches and a string of
back-and-forth discussion with no clear testing results.  It is
unreasonsable and too error-prone to have me go picking through such a
thread attempting to work out which of those patches should be applied
and then writing people's changelogs for them.
