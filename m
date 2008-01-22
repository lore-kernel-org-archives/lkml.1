Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYAVJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYAVJ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbYAVJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:55:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668AbYAVJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:55:32 -0500
Date: Tue, 22 Jan 2008 10:55:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 reboot: Remove inb_p usage
Message-ID: <20080122095514.GB5722@elte.hu>
References: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> We are driving a motherboard port so use a 2uS explicit delay at this 
> point.

thanks, applied.

	Ingo
