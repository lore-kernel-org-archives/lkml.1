Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585Ab0AQHOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0AQHOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124Ab0AQHOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:14:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0AQHOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:14:32 -0500
Date: Sun, 17 Jan 2010 08:14:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [resend][PATCH 1/2] kprobetrace,doc: shell need single quote to
 use $ character
Message-ID: <20100117071411.GD19512@elte.hu>
References: <20100114111032.D720.A69D9226@jp.fujitsu.com>
 <4B4EA4F3.6090401@redhat.com>
 <20100114141650.6728.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114141650.6728.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > KOSAKI Motohiro wrote:
> > > shell interpret $val is as shell variable. thus we need quote if
> > > we use echo command.
> > > 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> > 
> > Hi Ingo and KOSAKI-san,
> > 
> > Sorry, now this patch conflicts with my patch(commit 1464010) on the
> > latest -tip tree. The patch drops $argN support, so I updated the
> > 1st example command.
> > 
> > Thank you,
> 
> Oh, I'm sorry. I didn't notice that.

Mind resending a version with the patch conflicts resolved?

Thanks,

	Ingo
