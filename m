Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbYGXK35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbYGXK35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGXK3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:29:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58091 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYGXK3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:29:46 -0400
Date: Thu, 24 Jul 2008 12:29:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86/paravirt/xen: properly fill out the ldt ops
Message-ID: <20080724102932.GD28817@elte.hu>
References: <4887A0CE.1090200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887A0CE.1090200@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0992]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> LTP testing showed that Xen does not properly implement 
> sys_modify_ldt().  This patch does the final little bits needed to 
> make the ldt work properly.

applied to tip/x86/xen, thanks Jeremy.

	Ingo
