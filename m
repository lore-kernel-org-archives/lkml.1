Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYDRVdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYDRVdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYDRVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:33:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYDRVd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:33:27 -0400
Date: Fri, 18 Apr 2008 23:33:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kgdb build fix
Message-ID: <20080418213313.GA29298@elte.hu>
References: <1208537678.17196.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208537678.17196.40.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0719]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> TF_MASK is no longer defined, use X86_EFLAGS_TF.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
