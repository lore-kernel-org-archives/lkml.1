Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYJQAme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYJQAme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYJQAmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:42:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:47069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYJQAmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:42:25 -0400
Subject: Re: [git pull] core kernel updates for v2.6.28
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
In-Reply-To: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
References: <20081015125023.GA6702@elte.hu>
	 <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 11:40:23 +1100
Message-Id: <1224204023.7654.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I didn't spot a problem with your hand-merge of the phys_addr_t
stuff, but that was a quick look, I'll let Becky test the FSL
platforms . However, one of my test configs broke with:


