Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbXB1BXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbXB1BXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXB1BXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:23:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49964 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbXB1BXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:23:06 -0500
Date: Wed, 28 Feb 2007 06:53:01 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070228012301.GH29179@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702261139.59130.rjw@sisk.pl> <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com> <20070227083741.GA85@tv-sign.ru> <200702272222.01289.rjw@sisk.pl> <20070227215314.GA427@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227215314.GA427@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 12:53:14AM +0300, Oleg Nesterov wrote:
> I think it is good. Srivatsa?

Maybe additional comments on why we don't skip vfork kernel tasks may be good. 
Otherwise looks ok to me. Thanks Rafael for making the changes!

-- 
Regards,
vatsa
