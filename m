Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYARKqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYARKqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYARKqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:46:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40688 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYARKqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:46:06 -0500
Date: Fri, 18 Jan 2008 11:45:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: remove casts
Message-ID: <20080118104553.GB8785@elte.hu>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> This is against x86/mm.

hm, it has checkpatch failures - the changes introduce some new 
whitespace damage. Patch looks good otherwise. (please resend against 
latest x86.git)

	Ingo
