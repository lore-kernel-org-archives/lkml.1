Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYCCHdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYCCHdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYCCHda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:33:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYCCHda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:33:30 -0500
Date: Mon, 3 Mar 2008 08:33:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org,
       Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: SCHED_IDLE documentation
Message-ID: <20080303073311.GB5934@elte.hu>
References: <1203376368.275756.252634247263.1.gpush@pokey> <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de> <200803030721.52869.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030721.52869.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3448]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> If we don't have any man page, what is the actual definition of 
> SCHED_IDLE anyway?

it's rather simple: "it's a priority level even lower priority than nice 
+19".

	Ingo
