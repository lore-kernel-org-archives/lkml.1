Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZBEMQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZBEMQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 07:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBEMQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 07:16:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:34999 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753161AbZBEMQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 07:16:31 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19tUVssK95tYViCabBl7x2BN+hNeFIQA/D96nKUwA
	Y7/pH0UTrbMNCS
Date: Thu, 5 Feb 2009 13:16:24 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12605] Suspend regression, hang after matroxfb
Message-ID: <20090205121624.GA17811@alice>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.2UE.zuYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <pWZw1SZjMCH.A.2UE.zuYiJB@chimera>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.29-rc3 (x86_64)
X-Uptime: 13:12:39 up  3:45,  7 users,  load average: 3.15, 2.29, 1.97
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12605
> Subject		: Suspend regression, hang after matroxfb
> Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> Date		: 2009-01-29 12:58 (7 days old)
> References	: http://thread.gmane.org/gmane.linux.power-management.general/12640
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://marc.info/?l=linux-kernel&m=123335902122029&w=4

with todays -git I still get the same error, I have seen that some of 
your PM patches got applied, seems the one I need wasnt one of them.

Greetings, Eric
