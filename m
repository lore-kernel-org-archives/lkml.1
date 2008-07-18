Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYGRLmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYGRLmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGRLms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:42:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGRLmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:42:47 -0400
Date: Fri, 18 Jul 2008 13:42:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: suppress sparse returning void warnings
Message-ID: <20080718114236.GE6875@elte.hu>
References: <1216329754.6029.29.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216329754.6029.29.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> include/asm/paravirt.h:1404:2: warning: returning void-valued expression
> include/asm/paravirt.h:1414:2: warning: returning void-valued expression

applied to tip/x86/paravirt-spinlocks - thanks Harvey.

	Ingo
