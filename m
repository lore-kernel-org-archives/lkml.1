Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYANIc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYANIc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYANIcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:32:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYANIcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:32:47 -0500
Date: Mon, 14 Jan 2008 09:32:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mboton@gmail.com" <mboton@gmail.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] x86: refactor ioport unification
Message-ID: <20080114083222.GE18296@elte.hu>
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com> <4786AF4C.6050509@gmail.com> <4786C2CF.4070204@zytor.com> <20080110220444.4c9efdec.kjwinchester@gmail.com> <20080111140346.GA13604@elte.hu> <20080112010443.GA5476@sequoia.sous-sol.org> <20080112010656.GD3627@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112010656.GD3627@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Chris Wright <chrisw@sous-sol.org> wrote:

> Refactor ioport unification to pull out common code.

thanks, applied. Looks quite a bit more logical this way.

	Ingo
