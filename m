Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZBXDz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZBXDz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBXDzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:55:17 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60551 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZBXDzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:55:16 -0500
Message-Id: <200902240354.n1O3sous011760@www262.sakura.ne.jp>
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: rjw@sisk.pl
Cc: kernel-testers@vger.kernel.org, frederik.deweerdt@xprog.eu,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Feb 2009 12:54:50 +0900
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.jjH.nzzoJB@chimera>
In-Reply-To: <LLno3yT_fnC.A.jjH.nzzoJB@chimera>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 24022009 #1657228, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
> Subject		: NULL pointer dereference at get_stats()
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2008-12-30 12:53 (56 days old)
> References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> 
I couldn't reproduce this problem in native and KVM environments.
This problem seems to be VMware specific and priority is low.
Alok Kataria queued this problem.
Thus, this problem has not yet solved but mainline kernels don't need to wait
for this problem.
