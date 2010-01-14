Return-Path: <linux-kernel-owner+w=401wt.eu-S932078Ab0ANFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0ANFRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973Ab0ANFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:17:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50386 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab0ANFRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:17:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [resend][PATCH 1/2] kprobetrace,doc: shell need single quote to use $ character
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B4EA4F3.6090401@redhat.com>
References: <20100114111032.D720.A69D9226@jp.fujitsu.com> <4B4EA4F3.6090401@redhat.com>
Message-Id: <20100114141650.6728.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 14:17:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > shell interpret $val is as shell variable. thus we need quote if
> > we use echo command.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Hi Ingo and KOSAKI-san,
> 
> Sorry, now this patch conflicts with my patch(commit 1464010) on the
> latest -tip tree. The patch drops $argN support, so I updated the
> 1st example command.
> 
> Thank you,

Oh, I'm sorry. I didn't notice that.



