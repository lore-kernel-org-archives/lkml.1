Return-Path: <linux-kernel-owner+w=401wt.eu-S1750812AbXB0VxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812AbXB0VxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXB0VxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:53:21 -0500
Received: from mail.screens.ru ([213.234.233.54]:47964 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXB0VxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:53:20 -0500
Date: Wed, 28 Feb 2007 00:53:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070227215314.GA427@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com> <20070227083741.GA85@tv-sign.ru> <200702272222.01289.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702272222.01289.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Rafael J. Wysocki wrote:
>
> Okay, patch updated, appended.

I think it is good. Srivatsa?

Oleg.

