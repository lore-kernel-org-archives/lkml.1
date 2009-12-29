Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZL2SkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZL2SkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZL2SkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:40:22 -0500
Received: from lo.gmane.org ([80.91.229.12]:43835 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZL2SkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:40:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: [Bug #14923] Regression in 2.6.32.2: segfault on halt
Date: Tue, 29 Dec 2009 19:39:49 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2009.12.29.18.39.47.926000@googlemail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A._IH.RnhOLB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-79.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009 16:09:59 +0100, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14923
> Subject		: Regression in 2.6.32.2: segfault on halt
> Submitter	: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
> Date		: 2009-12-19 15:10 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=126123574505069&w=4
> Handled-By	: Mike Galbraith <efault@gmx.de>

Problem found, fixed by later commit as reported in:
http://marc.info/?l=linux-kernel&m=126138815719603&w=4

-h


