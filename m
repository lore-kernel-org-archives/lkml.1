Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYGGAwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYGGAwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 20:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYGGAwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 20:52:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:39640 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbYGGAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 20:52:14 -0400
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 10:51:36 +1000
Message-Id: <1215391896.8970.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 13:39 +0200, Rafael J. Wysocki wrote:
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10714
> Subject         : powerpc: Badness seen on 2.6.26-rc2 with lockdep
> enabled
> Submitter       : Balbir Singh <balbir@linux.vnet.ibm.com>
> Date            : 2008-05-14 12:57 (54 days old)
> References      :
> http://marc.info/?l=linux-kernel&m=121076917429133&w=4
> Handled-By      : Benjamin Herrenschmidt <benh@kernel.crashing.org>


Still can't reproduce that one, waiting to get access to Balbir's
machine.

Cheers,
Ben.


