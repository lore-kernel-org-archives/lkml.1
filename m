Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZLNHx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZLNHx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZLNHxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:53:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZLNHxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:53:25 -0500
Date: Mon, 14 Dec 2009 08:51:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] perf bench: Add "all" pseudo subsystem and "all"
 pseudo suite
Message-ID: <20091214075115.GA29677@elte.hu>
References: <20091212105554.GA9345@elte.hu>
 <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> Sorry, you are right, Ingo.
> This was my careless miss. sched-pipe.c returned twice.
> I wronged gcc by a false charge, sorry :(

Dont worry about it too much - GCC is guilty enough times :)

> This is version 2.

Great patch, applied, thanks!

	Ingo
