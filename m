Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYEDJKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYEDJKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYEDJKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:10:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbYEDJKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:10:15 -0400
Date: Sun, 4 May 2008 11:09:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #479 for v2.6.26-rc1-6-gafa26be :redefinition of
	'sysfs_update_group'
Message-ID: <20080504090959.GD29318@elte.hu>
References: <200805041053.43284.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805041053.43284.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0052]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Toralf Förster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :

fixed by:

  http://lkml.org/lkml/2008/5/4/21

	Ingo
