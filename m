Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYCYK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYCYK7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYCYK65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:58:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYCYK64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:58:56 -0400
Date: Tue, 25 Mar 2008 11:58:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Message-ID: <20080325105840.GB3729@elte.hu>
References: <200803242324.35357.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803242324.35357.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0470]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> [PATCH] x86: pat cpu feature bit setting for known cpus

thanks, applied - we need this to widen the testing scope of the PAT 
changes.

	Ingo
