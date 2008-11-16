Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYKPUaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYKPUaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYKPUaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:30:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4632 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752253AbYKPUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:30:06 -0500
Date: Sun, 16 Nov 2008 15:30:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.28-rc5: Reported regressions from 2.6.27
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
Message-ID: <Pine.LNX.4.44L0.0811161527410.14867-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
> Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
> Submitter	: Tejun Heo <tj@kernel.org>
> Date		: 2008-10-26 9:46 (22 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
> References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4

I believe this was fixed by commit 
2920ebbd65f3e80c318adf5191ac0987142bda80.  Tejun, isn't that right?

Alan Stern

