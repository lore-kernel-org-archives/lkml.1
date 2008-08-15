Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYHOXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYHOXVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYHOXVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:21:12 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:7053 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYHOXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:21:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Date: Fri, 15 Aug 2008 17:21:07 -0600
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Fg.4CjnIB@albercik>
In-Reply-To: <cX_-nNkxKaF.A.Fg.4CjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808151721.08175.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008 04:43:51 pm Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
> Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-06 17:18 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
> 		  http://lkml.org/lkml/2008/7/22/353
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: http://lkml.org/lkml/2008/7/22/364

Since I supplied a patch, I assume I don't need to do anything more.
Let me know if my assumption is incorrect.

Bjorn
