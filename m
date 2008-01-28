Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYA1Uzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYA1Uzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYA1Uzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:55:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbYA1Uzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:55:35 -0500
Date: Mon, 28 Jan 2008 21:54:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joachim Deguara <joachim.deguara@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       yinghai.lu@sun.com, Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
Message-ID: <20080128205441.GA13442@elte.hu>
References: <200801281211.28214.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801281211.28214.joachim.deguara@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joachim Deguara <joachim.deguara@amd.com> wrote:

>     x86: add PCI IDs to k8topology_64.c
>     
>     This just adds the PCI IDs of AMD's family 10h and 11h CPU's 
>  northbridges to k8topology discovery.

thanks Joachim, applied.

	Ingo
