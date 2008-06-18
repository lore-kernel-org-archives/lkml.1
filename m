Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbYFRHr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbYFRHr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYFRHrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:47:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbYFRHro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:47:44 -0400
Date: Wed, 18 Jun 2008 09:47:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Message-ID: <20080618074728.GB4135@elte.hu>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213294763-19566-2-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Robert Richter <robert.richter@amd.com> wrote:

> "Form follows function". Code is now where it belongs to.

applied to tip/x86/cpu - thanks.

	Ingo
