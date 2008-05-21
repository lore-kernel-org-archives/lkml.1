Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbYEUGal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbYEUGal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934330AbYEUGaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:30:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763858AbYEUGaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:30:13 -0400
Date: Wed, 21 May 2008 08:29:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mkrufky@linuxtv.org
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, pb@linuxtv.org,
       Stoth@hauppauge.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [patch] fix build error in drivers/media/video/cx23885/cx2388
	5-dvb.c
Message-ID: <20080521062955.GA28294@elte.hu>
References: <20080520153248.GA13562@elte.hu> <4832F956.90708@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832F956.90708@linuxtv.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0392]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* mkrufky@linuxtv.org <mkrufky@linuxtv.org> wrote:

> Please see below, proper patch attached...

thanks, this too solves the build problem.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
