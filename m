Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYFAAqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYFAAqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYFAAp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:47243 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbYFAAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Nv7zxySwDI4g+RdY3ZCt+EgaqHFTZAO7dJvTQcOM/aEiHY/YUmnQcF2GKh3EjQQRmFPi0lH4Tt17R7Zt/D0/Sg4FcP8QqyeADUubpWqjSl3RgEYGXCBZKGyYlmFxrtlg9PG8OXoN5UgHdm+6zOEbO2/nSkh0PIDrgmMSVMsJVYo=
Message-ID: <4841F129.8020105@googlemail.com>
Date: Sun, 01 Jun 2008 02:45:29 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.JmF.LtZQIB@albercik>
In-Reply-To: <UJSav77TyUB.A.JmF.LtZQIB@albercik>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.


No

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
> Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
> Submitter	: Gabriel C <nix.or.die@googlemail.com>
> Date		: 2008-05-08 00:26 (24 days old)
> References	: http://lkml.org/lkml/2008/5/7/352
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		  Peter Zijlstra <peterz@infradead.org>
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10648#c3
> 
> 


This problem is fixed in linus tree by a381759d6ad5c5dea5a981918e0b4493e9b66ac7

Gabriel



