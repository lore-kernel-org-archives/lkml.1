Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbYD1L1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbYD1L1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbYD1L12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:27:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34880 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762540AbYD1L11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:27:27 -0400
Date: Mon, 28 Apr 2008 13:27:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080428112714.GB18074@elte.hu>
References: <1209268817.14173.43.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209268817.14173.43.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> As written, this can never be true.

thanks Harvey, applied. Found via Sparse?

	Ingo
