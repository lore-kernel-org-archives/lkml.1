Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYFPL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYFPL1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFPL1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:27:33 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2981 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYFPL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:27:32 -0400
Subject: Re: [Bug 10905] 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY
	?
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>
In-Reply-To: <Jn7irxIunJK.A.QLD.qIDVIB@albercik>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.QLD.qIDVIB@albercik>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 13:26:22 +0200
Message-Id: <1213615582.19372.2.camel@n2o.xs4all.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-14 at 22:12 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10905
> Subject		: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
> Submitter	: Miquel van Smoorenburg <miquels@cistron.nl>
> Date		: 2008-05-21 13:30 (25 days old)
> References	: http://lkml.org/lkml/2008/5/21/131
> 		  http://lkml.org/lkml/2008/6/12/121
> Handled-By	: Glauber Costa <gcosta@redhat.com>
> 		  Andi Kleen <andi@firstfloor.org>
> 		  Miquel van Smoorenburg <mikevs@xs4all.net>
> Patch		: http://lkml.org/lkml/2008/5/28/42

This bug was recently fixed in 2.6.26 by commit
0269c5c6d9a9de22715ecda589730547435cd3e8

Mike.

