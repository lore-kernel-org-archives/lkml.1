Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYFLJv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYFLJv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYFLJvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:51:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYFLJvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:51:45 -0400
Date: Thu, 12 Jun 2008 11:51:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] tracer: fix printout
Message-ID: <20080612095121.GC25908@elte.hu>
References: <1213262823-31560-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213262823-31560-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Do not print loglevel before "entries of %ld bytes". Move it to the 
> previous pr_info.

applied to tip/tracing/ftrace - thanks Jiri.

	Ingo
