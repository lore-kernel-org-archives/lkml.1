Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbYKWRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbYKWRPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYKWRPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:15:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4230 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751632AbYKWRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:15:21 -0500
Date: Sun, 23 Nov 2008 12:15:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.28-rc6-git1: Reported regressions from 2.6.27
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
Message-ID: <Pine.LNX.4.44L0.0811231213250.24692-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
> Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
> Submitter	: Tejun Heo <tj@kernel.org>
> Date		: 2008-10-26 9:46 (28 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
> References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4

This has been fixed by commit 2920ebbd65f3e80c318adf5191ac0987142bda80.

Alan Stern

