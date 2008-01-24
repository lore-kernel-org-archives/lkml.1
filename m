Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYAXQDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYAXQDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYAXQDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:03:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYAXQDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:03:34 -0500
Date: Thu, 24 Jan 2008 17:03:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Unify fault_32|64.c by ifdef'd function bodies
Message-ID: <20080124160313.GD4857@elte.hu>
References: <1201046803.16972.92.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201046803.16972.92.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0606]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> It's about time to get on with unifying these files, elimination of 
> the ugly ifdefs can occur in the unified file.

thanks, i could apply the first two patches - but not the third one 
because some small differences crept in. I've done that by hand. Nice 
work btw!

	Ingo
