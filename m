Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbYBSLYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbYBSLYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762294AbYBSLXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:23:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762212AbYBSLXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:23:42 -0500
Date: Tue, 19 Feb 2008 12:23:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
Message-ID: <20080219112322.GD7204@elte.hu>
References: <200802190319.28699.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190319.28699.yinghai.lu@sun.com>
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

> please check some amd opteron related mmconf and numa patches
> 
> could make up for system that system have acpi problem or still can 
> mmconf and numa when acpi=off

Greg, any deep objections against these patches? (other than that they 
need a good amount of testing) I personally think that the more 
independent the kernel is of the whims of the BIOS, the better ...

	Ingo
