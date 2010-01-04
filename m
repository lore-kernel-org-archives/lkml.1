Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095Ab0ADURF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0ADURF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0ADURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:17:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0ADURA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:17:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
Date: Mon, 4 Jan 2010 21:17:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <200912302239.28792.rjw@sisk.pl> <cb0375e11001011917y6920d45dse0b507287e8538c@mail.gmail.com>
In-Reply-To: <cb0375e11001011917y6920d45dse0b507287e8538c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001042117.30740.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Andrew Lutomirski wrote:
> I suspect it was fixed by this patch:
> 
> http://lkml.org/lkml/2009/12/20/88
> 
> but I can't test because the machine in question died right after I
> built it a new kernel.  sigh.
> 
> I'll re-post once I get the laptop working again if there's still a problem.

OK, assume it's been fixed, so closing.

Please reopen if it's not fixed in fact.

Rafael
