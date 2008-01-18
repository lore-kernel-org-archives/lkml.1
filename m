Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbYARMlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbYARMlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYARMl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:41:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761017AbYARMl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:41:26 -0500
Date: Fri, 18 Jan 2008 13:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hpet_late_init hang
Message-ID: <20080118124116.GL11044@elte.hu>
References: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com> <200801161404.33519.balajirrao@gmail.com> <86802c440801161339h4e3e983co67e05a231666d050@mail.gmail.com> <200801172142.41787.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801172142.41787.balajirrao@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Balaji Rao <balajirrao@gmail.com> wrote:

> Ingo, here's the patch with the SOB. Please apply.

thanks - reinstated your original patch and added your fix too. I added:

 Signed-off-by: Balaji Rao <balajirrao@gmail.com>
 Tested-by: Yinghai Lu <yhlu.kernel@gmail.com>

	Ingo
