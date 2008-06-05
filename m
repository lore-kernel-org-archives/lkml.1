Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYFEVLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYFEVLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYFEVKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:10:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbYFEVKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:10:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
Date: Thu, 5 Jun 2008 23:11:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.JmF.LtZQIB@albercik> <4841F129.8020105@googlemail.com>
In-Reply-To: <4841F129.8020105@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052311.23893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 of June 2008, Gabriel C wrote:
> Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> 
> No
> 
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
> > Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
> > Submitter	: Gabriel C <nix.or.die@googlemail.com>
> > Date		: 2008-05-08 00:26 (24 days old)
> > References	: http://lkml.org/lkml/2008/5/7/352
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 		  Peter Zijlstra <peterz@infradead.org>
> > Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10648#c3
> > 
> > 
> 
> 
> This problem is fixed in linus tree by a381759d6ad5c5dea5a981918e0b4493e9b66ac7

Thanks, closed.

Rafael
