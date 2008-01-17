Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYAQMoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYAQMoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYAQMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:44:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYAQMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:44:10 -0500
Date: Thu, 17 Jan 2008 13:43:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable PAT for more AMD CPUs
Message-ID: <20080117124357.GA23340@elte.hu>
References: <20080117123613.GA22563@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117123613.GA22563@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> I checked some K7 errata files and couldn't find anything related to 
> PAT.  Also for Fam10h and 11h it should be definitely enabled.
> 
> Enable PAT for all AMD CPUs >= 6, which is K7 and newer.

thanks, applied.

	Ingo
