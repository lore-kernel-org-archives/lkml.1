Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYBEFHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYBEFHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYBEFHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:07:22 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49934 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbYBEFHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:07:21 -0500
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matteo Tescione <matteo@rmnet.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Mike Christie <michaelc@cs.wisc.edu>,
       Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <C3CDA7EE.5784%matteo@rmnet.it>
References: <C3CDA7EE.5784%matteo@rmnet.it>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 23:07:12 -0600
Message-Id: <1202188032.3096.196.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 05:43 +0100, Matteo Tescione wrote:
> Hi all,
> And sorry for intrusion, i am not a developer but i work everyday with iscsi
> and i found it fantastic.
> Altough Aoe, Fcoe and so on could be better, we have to look in real world
> implementations what is needed *now*, and if we look at vmware world,
> virtual iron, microsoft clustering etc, the answer is iSCSI.
> And now, SCST is the best open-source iSCSI target. So, from an end-user
> point of view, what are the really problems to not integrate scst in the
> mainstream kernel?

The fact that your last statement is conjecture.  It's definitely untrue
for non-IB networks, and the jury is still out on IB networks.

James


