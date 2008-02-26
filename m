Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbYBZJxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbYBZJxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbYBZJxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:53:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40503 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYBZJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:53:38 -0500
Date: Tue, 26 Feb 2008 18:52:00 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: glebn@voltaire.com (Gleb Natapov)
Subject: Re: [ofa-general] Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Holt <holt@sgi.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Izik Eidus <izike@qumranet.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080226093809.GF26611@minantech.com>
References: <200802261952.42567.nickpiggin@yahoo.com.au> <20080226093809.GF26611@minantech.com>
Message-Id: <20080226184914.FF3A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Can you change the spec?
> > >
> > > Not really. It will break all existing codes.
> > 
> > I meant as in eg. submit changes to MPI-3
>
> MPI spec tries to be backward compatible. And MPI-2 spec is 10 years
> old, but MPI-1 is still in a wider use. HPC is moving fast in terms of HW
> technology, but slow in terms of SW. Fortran is still hot there :)

Agreed.
many many people dislike incompatible specification change.

We should accept real world spec.


- kosaki


