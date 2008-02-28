Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbYB1HSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbYB1HSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYB1HSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:18:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYB1HSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:18:39 -0500
Date: Thu, 28 Feb 2008 08:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080228071822.GA13571@elte.hu>
References: <1204180441-8540-2-git-send-email-matthew@wil.cx> <1204180441-8540-3-git-send-email-matthew@wil.cx> <1204180441-8540-4-git-send-email-matthew@wil.cx> <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204180441-8540-11-git-send-email-matthew@wil.cx>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> Semaphores are no longer performance-critical, so a generic C 
> implementation is better for maintainability, debuggability and 
> extensibility.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

very nice work!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
