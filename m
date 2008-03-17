Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYCQScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYCQScb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYCQScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:32:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYCQScY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:32:24 -0400
Date: Mon, 17 Mar 2008 19:31:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [git patches] libata fixes
Message-ID: <20080317183155.GA8667@elte.hu>
References: <20080317123524.GA22741@havoc.gtf.org> <20080317182905.GA8415@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317182905.GA8415@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3367]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


changing CONFIG_ACPI_DOCK=m to CONFIG_ACPI_DOCK=y works around the build 
problem.

	Ingo
