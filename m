Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZJLL2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZJLL2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZJLL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:28:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbZJLL2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:28:31 -0400
Date: Mon, 12 Oct 2009 13:27:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - enabling "__cold" functions
Message-ID: <20091012112745.GA11035@elte.hu>
References: <1255104899-27784-1-git-send-email-jolsa@redhat.com> <20091012111917.GA6934@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012111917.GA6934@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2261]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> any feedback on this one?

Steve said he's queueing it up. (But 3 days of delay, especially if it's 
over the weekend and if it's not an urgent fix is to be expected so 
please be patient.)

	Ingo
