Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYEMM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYEMM2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYEMM20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:28:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59037 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbYEMM2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:28:25 -0400
Date: Tue, 13 May 2008 14:28:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/6] x86: Unify current.h
Message-ID: <20080513122814.GB14973@elte.hu>
References: <20080510020947.803480649@sgi.com> <20080510021015.319814569@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510021015.319814569@sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> Simply stitch these together. There are just two definitions that are 
> shared but the file is resonably small and putting these things 
> together shows that further unifications requires a unification of the 
> per cpu / pda handling between both arches.

applied, thanks.

	Ingo
