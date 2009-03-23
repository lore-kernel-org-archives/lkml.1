Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZCWIgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZCWIgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZCWIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:35:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbZCWIfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:35:50 -0400
Date: Mon, 23 Mar 2009 09:35:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@suse.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090323083533.GE18837@elte.hu>
References: <200903231208.03723.knikanth@suse.de> <20090323170234.6A12.A69D9226@jp.fujitsu.com> <200903231357.41130.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903231357.41130.knikanth@suse.de>
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


one thing to note:

| CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
| Testing tracer nop: PASSED

so it's a Qemu session, right?

	Ingo
