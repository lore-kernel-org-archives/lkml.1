Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZLURYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZLURYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZLURYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:24:08 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:32911 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZLURYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:24:07 -0500
Date: Mon, 21 Dec 2009 18:23:33 +0100
From: "Carlos R. Mafra" <crmafra@aei.mpg.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33-rc1+ bisected (?) s2ram regression
Message-ID: <20091221172333.GA5641@Pilar.aei.mpg.de>
References: <20091221164608.GA3909@Pilar.aei.mpg.de>
 <1261414580.4314.181.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261414580.4314.181.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo 21.Dez'09 at 17:56:20 +0100, Peter Zijlstra wrote:
> On Mon, 2009-12-21 at 17:46 +0100, Carlos R. Mafra wrote:
> > After 2.6.33-rc1 suspend to RAM (echo mem > /sys/power/state) stopped working
> > on my Vaio. Plain 2.6.33-rc1 is fine.
> 
> http://lkml.org/lkml/2009/12/20/88

I tested it now, and the patch fixes the problem.
Thanks Peter!
