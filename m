Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbYBUDbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbYBUDbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYBUDa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:30:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37037 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYBUDa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:30:56 -0500
Date: Thu, 21 Feb 2008 04:30:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: remove double-checking empty zero pages debug
Message-ID: <20080221033046.GE27593@elte.hu>
References: <200802201853.17265.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802201853.17265.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> so far, no one complained that.

thanks Yinghai, applied.

	Ingo
