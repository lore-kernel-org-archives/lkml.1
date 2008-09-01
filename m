Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbYIAVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbYIAVUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYIAVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 17:20:35 -0400
Received: from www.tglx.de ([62.245.132.106]:57219 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYIAVUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 17:20:35 -0400
Date: Mon, 1 Sep 2008 23:20:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
In-Reply-To: <20080902004624.61f39cfe@gmail.com>
Message-ID: <alpine.LFD.1.10.0809012320050.3243@apollo.tec.linutronix.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.TJH.klbuIB@albercik> <20080902004624.61f39cfe@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Mikhail Kshevetskiy wrote:
> On Sat, 30 Aug 2008 21:50:13 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
> > Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
> > Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> > Date		: 2008-07-24 03:22 (38 days old)
> > References	: http://lkml.org/lkml/2008/7/23/317
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> > 
> > 
> 
> not fixed yet

Working on a debug patch.

	tglx

