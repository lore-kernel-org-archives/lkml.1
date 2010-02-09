Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0BIKOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:14:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:58975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0BIKOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:14:16 -0500
Subject: Re: Fwd: Possible performance improvement?
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <430c80e91002090127u1742d043ub29f1c547fe73590@mail.gmail.com>
References: <430c80e91002090103l5751d569pd306ca1f0ccca8ba@mail.gmail.com>
	 <430c80e91002090127u1742d043ub29f1c547fe73590@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 11:14:16 +0100
Message-ID: <1265710456.11509.181.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 14:57 +0530, Pranith Kumar wrote:

> I recently happened to come across this thesis[1] which
> presents some very concrete results with stats regarding
> the performance of Linux CFS with an implementation of Redline.
> 
> It would really be great if you could take some time out of your
> busy schedule and quickly look up the figures to see the performance
> comparison and if we could adapt some ideas. I am willing to give it
> a try if you think its worth it.

> [1] http://scholarworks.umass.edu/cgi/viewcontent.cgi?article=1071&context=open_access_dissertations

Looks to propose a rather simple semi-static edf based cpu scheduler.

If you're interested in that, there is a group actively working on a
deadline scheduler for linux: http://lkml.org/lkml/2009/10/16/161



