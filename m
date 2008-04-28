Return-Path: <linux-kernel-owner+w=401wt.eu-S935860AbYD1Szo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935860AbYD1Szo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933509AbYD1Szd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbYD1Szc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:55:32 -0400
Date: Mon, 28 Apr 2008 20:55:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] sched fixes for suboptimal balancing
Message-ID: <20080428185515.GF4491@elte.hu>
References: <480DDC48.BA47.005A.0@novell.com> <20080423111313.4981.37345.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423111313.4981.37345.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1720]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
> 
> Here are my proposed fixes for the issue Dmitry has highlighted in:
> 
> http://lkml.org/lkml/2008/4/22/296
> 
> This is an RFC, and it applies to sched-devel.

thanks Gregory - picked them up for more testing.

	Ingo
