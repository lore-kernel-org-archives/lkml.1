Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYDMIOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYDMIOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDMIOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:14:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49686 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbYDMIOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:14:34 -0400
Date: Sun, 13 Apr 2008 10:14:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: fix exec mappings comments
Message-ID: <20080413081421.GL20332@elte.hu>
References: <1207988905-17806-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207988905-17806-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0142]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> - noexec32 is on by default for years already
> - add noexec32 to kernel-parameters and fix noexec type in there

thanks Jiri, applied.

	Ingo
