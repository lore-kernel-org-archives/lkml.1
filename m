Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYB0PSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYB0PSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYB0PSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:18:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbYB0PSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:18:34 -0500
Date: Wed, 27 Feb 2008 16:18:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc3 regression] sysctl table check failed:
	/kernel/vsyscall64
Message-ID: <20080227151818.GA23138@elte.hu>
References: <200802271609.48450.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802271609.48450.elendil@planet.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> Just tried 2.6.25-rc3 and got the error below. Boot continued 
> normally. Error was not present in rc2.

fix is already in x86.git#testing:

  http://people.redhat.com/mingo/x86.git/README

	Ingo
